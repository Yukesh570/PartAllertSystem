package com.parkAlert.Parkalert;

import android.Manifest;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
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

public class BluetoothReceiver extends BroadcastReceiver {

    public static final String CHANNEL_ID = "bluetooth_channel";
    public static MethodChannel channel;

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        Log.d("BluetoothReceiver", "Received action: " + action);

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
                    Log.d("BluetoothReceiver", "GeofenceForegroundService stopped after 7s");
                }, 7000L);

                handleBluetoothEvent(context, device, true, matchingRingerJson);

            } else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
                Log.d("BluetoothReceiver", "Disconnected: " + device.getName());

                new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
                    context.stopService(serviceIntent);
                    Log.d("BluetoothReceiver", "GeofenceForegroundService stopped after 10s");
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
                Log.d("BluetoothReceiver", "Full Match Found! Name: " + targetBluetooth + " Trigger: " + triggerType);
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
            foregroundService = ActivityCompat.checkSelfPermission(context, Manifest.permission.FOREGROUND_SERVICE_LOCATION)
                    == PackageManager.PERMISSION_GRANTED;
        }

        boolean location = ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
                == PackageManager.PERMISSION_GRANTED ||
                ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
                        == PackageManager.PERMISSION_GRANTED;

        boolean background = true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            background = ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_BACKGROUND_LOCATION)
                    == PackageManager.PERMISSION_GRANTED;
        }

        return foregroundService && location && background;
    }

    private void handleBluetoothEvent(Context context, BluetoothDevice device, boolean connected, String ringerJson) {
        new android.os.Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
            @Override
            public void run() {
                SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
                boolean isInsideGeofence = prefs.getBoolean("flutter.insideGeofence", false);

                if (ringerJson == null || ringerJson.isEmpty()) return;

                // 1. Trigger Flutter MethodChannel
                if (channel != null) {
                    new android.os.Handler(Looper.getMainLooper()).post(() -> {
                        channel.invokeMethod("triggerAlarmPopup", ringerJson);
                    });
                }

                // 2. Local Android Notification Logic
                try {
                    JSONObject jsonObject = new JSONObject(ringerJson);
                    String targetName = jsonObject.optString("name", "");
                    String targetSound = jsonObject.optString("sound", "");
                    String targetVibration = jsonObject.optString("vibration", "true");
                    String targetOverSilent = jsonObject.optString("overRideSilence", "false");

                    Log.d("BluetoothReceiver", "Processing event for Ringer: " + targetName);
                    getCurrentLocation(context, targetName, connected);

                    if (!isInsideGeofence) {
                        showNotification(context, device.getName(), targetName, connected, targetSound, targetVibration, targetOverSilent);
                    } else {
                        Log.d("BluetoothReceiver", "Inside geofence → skipping notification");
                    }

                } catch (JSONException e) {
                    Log.e("BluetoothReceiver", "JSON Error: " + e.getMessage());
                }
            } // Closing run()
        }, 2000); // Closing postDelayed
    } // Closing handleBluetoothEvent

    private void getCurrentLocation(Context context, String targetName, boolean connected) {
        FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(context);
        if (!hasRequiredPermissions(context)) return;

        fusedLocationClient.getLastLocation()
                .addOnSuccessListener(location -> {
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

    private void showNotification(Context context, String deviceName, String targetName, boolean connected,
                                  String targetSound, String targetVibration, String targetOverSilent) {

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
                            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build();
                    channel.setSound(soundUri, audioAttributes);
                }
                notificationManager.createNotificationChannel(channel);
            }
        }

        Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
        PendingIntent pendingIntent = PendingIntent.getActivity(
                context, 0, launchIntent != null ? launchIntent : new Intent(),
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        String title = connected ? targetName : targetName;
        String text = deviceName + (connected ? " connected!" : " disconnected!");

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, channelId)
                .setSmallIcon(context.getApplicationInfo().icon)
                .setContentTitle(title)
                .setContentText(text)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent);

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

        notificationManager.notify((int) System.currentTimeMillis(), builder.build());
    }
}