package com.parkAlert.Parkalert;

import android.Manifest;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.content.SharedPreferences;
import android.util.Log;
import android.media.AudioAttributes;
import android.net.Uri;
import android.bluetooth.BluetoothDevice;
import androidx.core.app.NotificationCompat;
import io.flutter.plugin.common.MethodChannel;
import org.json.JSONObject;
import org.json.JSONException;
import org.json.JSONArray;
import android.location.Location;
import android.os.Looper;
import android.media.AudioManager;
import java.util.Set;
import android.os.PowerManager;
public class BluetoothReceiver extends BroadcastReceiver {

    public static final String CHANNEL_ID = "bluetooth_channel";
    public static MethodChannel channel;

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        Log.d("BluetoothReceiver", "Received action: " + action);

        // ==========================================
        // 1. HANDLE NATIVE SNOOZE BUTTON
        // ==========================================
        if ("ACTION_SNOOZE".equals(action)) {
            int notifId = intent.getIntExtra("notifId", 999);
            NotificationManager nm = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            nm.cancel(notifId); // Clear current notification

            String ringerJson = intent.getStringExtra("ringerJson");
            String deviceName = intent.getStringExtra("deviceName");
            boolean connected = intent.getBooleanExtra("connected", true);

            // Schedule Native Alarm for 10 seconds (Change to 300000 for 5 mins)
            AlarmManager am = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            Intent alarmIntent = new Intent(context, BluetoothReceiver.class);
            alarmIntent.setAction("ACTION_TRIGGER_ALARM");
            alarmIntent.putExtra("ringerJson", ringerJson);
            alarmIntent.putExtra("deviceName", deviceName);
            alarmIntent.putExtra("connected", connected);

            PendingIntent pi = PendingIntent.getBroadcast(context, 123, alarmIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + 300000, pi);
            } else {
                am.setExact(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + 300000, pi);
            }
            Log.d("BluetoothReceiver", "Snoozed NATIVELY for 5 minutes");
            return;
        }

        // ==========================================
        // 2. HANDLE NATIVE QUIT BUTTON
        // ==========================================
        if ("ACTION_QUIT".equals(action)) {
            int notifId = intent.getIntExtra("notifId", 999);
            NotificationManager nm = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            nm.cancel(notifId);
            Log.d("BluetoothReceiver", "Quit clicked - Notification cleared");
            return;
        }

        // ==========================================
        // 3. HANDLE ALARM WAKEUP (After Snooze)
        // ==========================================
        if ("ACTION_TRIGGER_ALARM".equals(action)) {
            String ringerJson = intent.getStringExtra("ringerJson");
            String deviceName = intent.getStringExtra("deviceName");
            boolean connected = intent.getBooleanExtra("connected", true);
            
            // Re-fire the unified notification
            parseAndShowNotification(context, deviceName, connected, ringerJson);
            return;
        }

        // ==========================================
        // 4. NORMAL BLUETOOTH CONNECTION LOGIC
        // ==========================================
        BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
        if (device == null || device.getName() == null) return;
        boolean isConnecting = BluetoothDevice.ACTION_ACL_CONNECTED.equals(action);
        String matchingRingerJson = getMatchingRinger(context, device, isConnecting);

        if (matchingRingerJson != null) {
            if (!hasRequiredPermissions(context)) {
                Log.e("BluetoothReceiver", "Permissions missing, cannot start service");
                return;
            }

            Intent serviceIntent = new Intent(context, GeofenceForegroundService.class);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent);
            } else {
                context.startService(serviceIntent);
            }

            if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) {
                new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
                    context.stopService(serviceIntent);
                }, 7000L);
                handleBluetoothEvent(context, device, true, matchingRingerJson);

            } else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
                new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
                    context.stopService(serviceIntent);
                }, 10000L);
                handleBluetoothEvent(context, device, false, matchingRingerJson);
            }
        }
    }

    private String getMatchingRinger(Context context, BluetoothDevice device, boolean isConnecting) {
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        Object rawData = prefs.getAll().get("flutter.ringers");
        String connectedName = device.getName();

        if (rawData == null) return null;

        try {
            if (rawData instanceof Set) {
                for (String ringerJson : (Set<String>) rawData) {
                    if (isFullMatch(ringerJson, connectedName, isConnecting)) return ringerJson;
                }
            } else if (rawData instanceof String) {
                String dataString = (String) rawData;
                if (dataString.contains("![")) {
                    String jsonInside = dataString.substring(dataString.indexOf("![") + 2, dataString.lastIndexOf("]"));
                    String[] items = jsonInside.split("\",\"");
                    for (String item : items) {
                        String cleanJson = item.replaceFirst("^\"", "").replaceFirst("\"$", "").replace("\\\"", "\"");
                        if (isFullMatch(cleanJson, connectedName, isConnecting)) return cleanJson;
                    }
                } else {
                    if (isFullMatch(dataString, connectedName, isConnecting)) return dataString;
                }
            }
        } catch (Exception e) {
            Log.e("BluetoothReceiver", "Error: " + e.getMessage());
        }
        return null;
    }

    private boolean isFullMatch(String json, String deviceName, boolean isConnecting) {
        try {
            JSONObject jsonObject = new JSONObject(json);
            String targetBluetooth = jsonObject.optString("bluetooth", "");
            String triggerType = jsonObject.optString("triggerType", "Connect");

            boolean nameMatches = !targetBluetooth.isEmpty() && deviceName.contains(targetBluetooth);
            if (!nameMatches) return false;

            boolean triggerMatches = (triggerType.equalsIgnoreCase("Connect") && isConnecting) ||
                                    (triggerType.equalsIgnoreCase("Disconnect") && !isConnecting);

            if (triggerMatches) {
                return true;
            }
        } catch (JSONException e) {
            return false;
        }
        return false;
    }

    private boolean hasRequiredPermissions(Context context) {
        boolean foregroundService = true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            foregroundService = ActivityCompat.checkSelfPermission(context, Manifest.permission.FOREGROUND_SERVICE_LOCATION) == PackageManager.PERMISSION_GRANTED;
        }

        boolean location = ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED ||
                ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;

        boolean background = true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            background = ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_BACKGROUND_LOCATION) == PackageManager.PERMISSION_GRANTED;
        }

        return foregroundService && location && background;
    }

    private void handleBluetoothEvent(Context context, BluetoothDevice device, boolean connected, String ringerJson) {
        new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
            SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
            boolean isInsideGeofence = prefs.getBoolean("flutter.insideGeofence", false);

            if (ringerJson == null || ringerJson.isEmpty()) return;

            // ✅ Trigger UI to update if app is open
            if (channel != null) {
                new android.os.Handler(Looper.getMainLooper()).post(() -> {
                    java.util.Map<String, Object> args = new java.util.HashMap<>();
                    args.put("ringerJson", ringerJson);
                    args.put("deviceName", device.getName());
                    args.put("connected", connected);
                    channel.invokeMethod("triggerAlarmPopup", args);
                });
            }

            try {
                JSONObject jsonObject = new JSONObject(ringerJson);
                String targetName = jsonObject.optString("name", "");
                getCurrentLocation(context, targetName, connected);

                if (!isInsideGeofence) {
                    // ✅ Call the new Unified Notification
                    parseAndShowNotification(context, device.getName(), connected, ringerJson);
                } else {
                    Log.d("BluetoothReceiver", "Inside geofence → skipping notification");
                }

            } catch (JSONException e) {
                Log.e("BluetoothReceiver", "JSON Error: " + e.getMessage());
            }
        }, 2000);
    }

    private void parseAndShowNotification(Context context, String deviceName, boolean connected, String ringerJson) {
        try {
            JSONObject jsonObject = new JSONObject(ringerJson);
            String targetName = jsonObject.optString("name", "");
            String targetSound = jsonObject.optString("sound", "");
            String targetVibration = jsonObject.optString("vibration", "true");
            String targetOverSilent = jsonObject.optString("overRideSilence", "false");

            showUnifiedNotification(context, deviceName, connected, ringerJson, targetName, targetSound, targetVibration, targetOverSilent);
        } catch (JSONException e) {
            Log.e("BluetoothReceiver", "Parse Error: " + e.getMessage());
        }
    }

    private void getCurrentLocation(Context context, String targetName, boolean connected) {
        FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(context);
        if (!hasRequiredPermissions(context)) return;

        fusedLocationClient.getLastLocation().addOnSuccessListener(location -> {
            if (location != null) {
                saveCurrentLocation(context, location, targetName, connected);
            }
        });
    }

    private void saveCurrentLocation(Context context, Location location, String targetName, boolean connected) {
        try {
            SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
            JSONObject locObj = new JSONObject();
            locObj.put("lat", location.getLatitude());
            locObj.put("lng", location.getLongitude());
            locObj.put("time", System.currentTimeMillis());
            locObj.put("name", targetName);
            locObj.put("status", connected ? "Connected" : "Disconnected");

            String existingLocationsJson = prefs.getString("flutter.currentLocation", "[]");
            JSONArray locationsArray = new JSONArray(existingLocationsJson);
            locationsArray.put(locObj);

            prefs.edit().putString("flutter.currentLocation", locationsArray.toString()).apply();
            prefs.edit().putString("flutter.backupcurrentLocation", locationsArray.toString()).apply();
        } catch (JSONException e) {
            Log.e("BluetoothReceiver", "Failed to save location: " + e.getMessage());
        }
    }

    // ==========================================
    // 5. THE UNIFIED NATIVE NOTIFICATION
    // ==========================================
    // ==========================================
    // 5. THE UNIFIED NATIVE NOTIFICATION
    // ==========================================
    private void showUnifiedNotification(Context context, String deviceName, boolean connected, String ringerJson,
                                         String targetName, String targetSound, String targetVibration, String targetOverSilent) {

        int NOTIFICATION_ID = 999;
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        Uri soundUri = null;
        if (targetSound != null && !targetSound.isEmpty()) {
            soundUri = Uri.parse("android.resource://" + context.getPackageName() + "/raw/" + targetSound);
        }
        
        boolean vibrate = targetVibration == null || targetVibration.equalsIgnoreCase("true");
        boolean overRideSilence = targetOverSilent == null || targetOverSilent.equalsIgnoreCase("true");

        String channelId = "bluetooth_channel_" + targetSound + "_" + targetVibration + "_" + targetOverSilent;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = notificationManager.getNotificationChannel(channelId);
            if (channel == null) {
                channel = new NotificationChannel(channelId, "Bluetooth Events", NotificationManager.IMPORTANCE_HIGH);
                channel.enableLights(true);
                channel.setLightColor(Color.BLUE);
                if (vibrate) {
                    channel.enableVibration(true);
                    channel.setVibrationPattern(new long[]{0, 500, 200, 500});
                }
                if (soundUri != null) {
                    AudioAttributes audioAttributes = new AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM) 
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build();
                    channel.setSound(soundUri, audioAttributes);
                }
                notificationManager.createNotificationChannel(channel);
            }
        }

        // INTENT: SNOOZE
        Intent snoozeIntent = new Intent(context, BluetoothReceiver.class);
        snoozeIntent.setAction("ACTION_SNOOZE");
        snoozeIntent.putExtra("ringerJson", ringerJson);
        snoozeIntent.putExtra("deviceName", deviceName);
        snoozeIntent.putExtra("connected", connected);
        snoozeIntent.putExtra("notifId", NOTIFICATION_ID);
        PendingIntent snoozePI = PendingIntent.getBroadcast(context, 1, snoozeIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        // INTENT: QUIT
        Intent quitIntent = new Intent(context, BluetoothReceiver.class);
        quitIntent.setAction("ACTION_QUIT");
        quitIntent.putExtra("notifId", NOTIFICATION_ID);
        PendingIntent quitPI = PendingIntent.getBroadcast(context, 2, quitIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        // INTENT: OPEN APP ON TAP
        Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
        launchIntent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        launchIntent.putExtra("from_notification", true);
        launchIntent.putExtra("ringerJson", ringerJson);
        launchIntent.putExtra("deviceName", deviceName);
        launchIntent.putExtra("connected", connected);
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, launchIntent != null ? launchIntent : new Intent(), PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        String title = connected ? targetName : targetName;
        String text = deviceName + (connected ? " connected!" : " disconnected!");

        // BUILD UNIFIED NOTIFICATION
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, channelId)
                .setSmallIcon(context.getApplicationInfo().icon)
                .setContentTitle(title)
                .setContentText(text)
                .setPriority(NotificationCompat.PRIORITY_MAX) 
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setOngoing(true) 
                .setAutoCancel(false)
                .setContentIntent(pendingIntent)
                // ❌ DELETED: .setFullScreenIntent() -> This stops the app from force-opening!
                .addAction(0, "SNOOZE (5min)", snoozePI) 
                .addAction(0, "QUIT", quitPI); 

        // OVERRIDE SILENT MODE
        AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        int currentMode = audioManager.getRingerMode();

        if (overRideSilence && (currentMode == AudioManager.RINGER_MODE_SILENT || currentMode == AudioManager.RINGER_MODE_VIBRATE)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && notificationManager.isNotificationPolicyAccessGranted()) {
                audioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
                int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION);
                audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION, maxVolume, 0);
                
                new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
                    audioManager.setRingerMode(currentMode);
                }, 4000);
            }
        }

        // ✅ TURN ON THE SCREEN (So they can see the notification on the lock screen)
        PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
        if (pm != null && !pm.isInteractive()) {
            @SuppressWarnings("deprecation")
            PowerManager.WakeLock wl = pm.newWakeLock(PowerManager.FULL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP, "ParkAlarm:WakeLock");
            wl.acquire(4000); // Light up screen for 4 seconds
        }

        notificationManager.notify(NOTIFICATION_ID, builder.build());
    }
}