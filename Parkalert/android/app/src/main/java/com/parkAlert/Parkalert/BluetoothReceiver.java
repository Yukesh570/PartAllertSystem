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

public class BluetoothReceiver extends BroadcastReceiver {

    public static final String CHANNEL_ID = "bluetooth_channel";
    public static MethodChannel channel;

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        Log.d("BluetoothReceiver", "Received action: " + action);

        BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
        if (device == null || device.getName() == null) return;

        if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) {
            if (isTargetDevice(context, device)) {
                if (!hasRequiredPermissions(context)) {
                    Log.e("BluetoothReceiver", "Permissions missing, cannot start service");
                    return;
                }

                // Start foreground service
                Intent serviceIntent = new Intent(context, GeofenceForegroundService.class);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent);
                } else {
                    context.startService(serviceIntent);
                }

                    // Stop after 10 seconds

                new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
                    context.stopService(serviceIntent);
                    Log.d("BluetoothReceiver", "GeofenceForegroundService stopped after 10s on " + action);
                }, 7000L);
                // Handle connection event
                handleBluetoothEvent(context, device, true);
            }
        } 
        else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
            if (isTargetDevice(context, device)) {
                if (!hasRequiredPermissions(context)) {
                    Log.e("BluetoothReceiver", "Permissions missing, cannot start service");
                    return;
                }
            Log.d("BluetoothReceiver", "Disconnected: " + device.getName());
            // Start foreground service
                Intent serviceIntent = new Intent(context, GeofenceForegroundService.class);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent);
                } else {
                    context.startService(serviceIntent);
                }

                    // Stop after 10 seconds

                new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
                    context.stopService(serviceIntent);
                }, 10000L);
            handleBluetoothEvent(context, device, false);
            }
               
        }
    }

    private boolean isTargetDevice(Context context, BluetoothDevice device) {
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        String jsonString = prefs.getString("flutter.activeBluetooth", "");
        String targetBluetoothName = "";
        try {
            if (!jsonString.isEmpty()) {
                JSONObject jsonObject = new JSONObject(jsonString);
                targetBluetoothName = jsonObject.optString("bluetooth", "");
            }
        } catch (JSONException e) { 
            Log.e("BluetoothReceiver", "JSON parse error: " + e.getMessage());
        }

        return !targetBluetoothName.isEmpty() && device.getName().contains(targetBluetoothName);
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

    private void handleBluetoothEvent(Context context, BluetoothDevice device, boolean connected) {
        new android.os.Handler(context.getMainLooper()).postDelayed(new Runnable() {
                    @Override
                    public void run() {

        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        String jsonString = prefs.getString("flutter.activeBluetooth", "");
        boolean isInsideGeofence = prefs.getBoolean("flutter.insideGeofence", false);


        String targetBluetoothName = "";
        String targetSound = "";
        String targetName = "";
        String targetVibration = "";
        String targetOverSilent ="";
        // Skip if nothing stored
        if (jsonString == null || jsonString.trim().isEmpty()) {
            Log.d("BluetoothReceiver", "⚠ Skipping notification - no activeBluetooth data found");
            return;
        }
        
        try {
            JSONObject jsonObject = new JSONObject(jsonString);
            targetBluetoothName = jsonObject.optString("bluetooth", "");
            targetSound = jsonObject.optString("sound", "");
            targetName = jsonObject.optString("name", "");
            targetVibration = jsonObject.optString("vibration","true");
            targetOverSilent =jsonObject.optString("overRideSilence","true");
        } catch (JSONException e) {
            Log.e("BluetoothReceiver", "Failed to parse JSON: " + e.getMessage());
            return; // If JSON is invalid, don’t proceed
        }
        // Skip if bluetooth field itself is empty
        if (targetBluetoothName.isEmpty()) {
        Log.d("BluetoothReceiver", "⚠ Skipping notification - bluetooth field is empty");
        return;
    }
        

        if (device.getName().contains(targetBluetoothName)) {
           
                    getCurrentLocation(context, targetName,connected);
                
            if (!isInsideGeofence) {

                showNotification(context, device.getName(),targetName, connected, targetSound,targetVibration,targetOverSilent);
            } else {
                Log.d("BluetoothReceiver", "Inside geofence → skipping notification");
            }
        }
    }
        },2000); // 3 second delay to ensure GeofenceService has updated the value
    }

    private void getCurrentLocation(Context context, String targetName, boolean connected) {
        FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(context);
        if (!hasRequiredPermissions(context)) {
            Log.e("BluetoothReceiver", "❌ Location permission not granted");
            return;
        }

        fusedLocationClient.getLastLocation()
                .addOnSuccessListener(location -> {
                    if (location != null) {
                        saveCurrentLocation(context, location, targetName,connected);
                    } else {
                        Log.d("BluetoothReceiver", "❌ No last known location available.");
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

            String backupLocationsJson = prefs.getString("flutter.backupcurrentLocation", "[]");
            JSONArray backuplocationsArray = new JSONArray(backupLocationsJson);
            backuplocationsArray.put(locObj);

            prefs.edit().putString("flutter.currentLocation", locationsArray.toString()).apply();
            prefs.edit().putString("flutter.backupcurrentLocation", locationsArray.toString()).apply();



        } catch (JSONException e) {
            Log.e("BluetoothReceiver", "Failed to save location: " + e.getMessage());
        }
    }



    private void showNotification(Context context, String deviceName,String targetName, boolean connected,
                              String targetSound, String targetVibration, String targetOverSilent) {

    NotificationManager notificationManager =
            (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

    Uri soundUri = null;
    if (targetSound != null && !targetSound.isEmpty()) {
        soundUri = Uri.parse("android.resource://" + context.getPackageName() + "/raw/" + targetSound);
    }
    boolean vibrate = targetVibration == null || targetVibration.equalsIgnoreCase("true");
    boolean overRideSilence = targetOverSilent == null || targetOverSilent.equalsIgnoreCase("true");

    String channelId = "bluetooth_channel_" + (targetSound != null ? targetSound : "default") + "_" + targetVibration + "_" + targetOverSilent;

    // Create notification channel if necessary
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        notificationManager.deleteNotificationChannel(channelId); // 👈 Add this

        NotificationChannel channel = notificationManager.getNotificationChannel(channelId);
        if (channel == null) {
            channel = new NotificationChannel(
                    channelId,
                    "Bluetooth Events",
                    NotificationManager.IMPORTANCE_HIGH
            );
            channel.setDescription("Notifications for Bluetooth events");
            channel.enableLights(true);
            channel.setLightColor(Color.BLUE);

            if (vibrate) {
                channel.enableVibration(true);
                channel.setVibrationPattern(new long[]{0, 500, 200, 500});
            }
            else{
                channel.enableVibration(false);
                channel.setVibrationPattern(null);
            }

            if (soundUri != null) {
                AudioAttributes audioAttributes = new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build();
                if (overRideSilence && Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                channel.setSound(soundUri, audioAttributes);
                channel.setImportance(NotificationManager.IMPORTANCE_HIGH);
                channel.setBypassDnd(true); // Already helps for DND
            } else {
                channel.setSound(soundUri, audioAttributes);
                channel.setImportance(NotificationManager.IMPORTANCE_HIGH);
            }
            }

            notificationManager.createNotificationChannel(channel);
        }
    }

    Intent intent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
    if (intent != null) {
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
    }

    PendingIntent pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent != null ? intent : new Intent(),
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
    );

    // String title = connected ? "Exiting The Parking" : "ParkAlert is Activated";
    String title = connected ? targetName + ": Exiting The Parking" : targetName + ": ParkAlert is Activated";
    String text = deviceName + (connected ? " connected!" : " disconnected!");
    // String text = targetName +" (" + deviceName + ")"+(connected ? "connected!" : "disconnected!");

    NotificationCompat.Builder builder = new NotificationCompat.Builder(context, channelId)
            .setSmallIcon(context.getApplicationInfo().icon)
            .setContentTitle(title)
            .setContentText(text)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent);

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
        if (soundUri != null) {
            builder.setSound(soundUri);
        } else {
            builder.setDefaults(NotificationCompat.DEFAULT_ALL);
        }
    }

AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
int currentMode = audioManager.getRingerMode();
int originalVolume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM);
NotificationManager nm = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);


//override silence mode for 5 seconds
if (overRideSilence && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
    if (!nm.isNotificationPolicyAccessGranted()) {
        // Open settings screen so the user can grant access
        Intent settingsIntent = new Intent(android.provider.Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
        settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(settingsIntent);
        return; // Avoid crash
    } else if (currentMode == AudioManager.RINGER_MODE_SILENT|| currentMode == AudioManager.RINGER_MODE_VIBRATE) {
        audioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
        int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION);
        audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION, maxVolume, 0);
    }
}

// Send notification
notificationManager.notify((int) System.currentTimeMillis(), builder.build());

// restore original mode after delay
if(currentMode == AudioManager.RINGER_MODE_SILENT || currentMode == AudioManager.RINGER_MODE_VIBRATE){
    new android.os.Handler(Looper.getMainLooper()).postDelayed(() -> {
    audioManager.setRingerMode(currentMode);
    audioManager.setStreamVolume(AudioManager.STREAM_ALARM, originalVolume, 0);
}, 4000);}
}


}
