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

                Log.d("BluetoothReceiver", "GeofenceForegroundService started immediately");

                // Handle connection event
                handleBluetoothEvent(context, device, true);
            }
        } 
        else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
            Log.d("BluetoothReceiver", "Disconnected: " + device.getName());
            handleBluetoothEvent(context, device, false);

            // Stop Geofence service
            Intent serviceIntent = new Intent(context, GeofenceForegroundService.class);
            context.stopService(serviceIntent);
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

        Log.d("BluetoothReceiver", "Permissions - Foreground: " + foregroundService + ", Location: " + location + ", Background: " + background);
        return foregroundService && location && background;
    }

    private void handleBluetoothEvent(Context context, BluetoothDevice device, boolean connected) {
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        String jsonString = prefs.getString("flutter.activeBluetooth", "");
        boolean isInsideGeofence = prefs.getBoolean("flutter.insideGeofence", false);
        String targetBluetoothName = "";
        String targetSound = "";
        String targetName = "";

        if (!jsonString.isEmpty()) {
            try {
                JSONObject jsonObject = new JSONObject(jsonString);
                targetBluetoothName = jsonObject.optString("bluetooth", "");
                targetSound = jsonObject.optString("sound", "");
                targetName = jsonObject.optString("name", "");
            } catch (JSONException e) {
                Log.e("BluetoothReceiver", "Failed to parse JSON: " + e.getMessage());
            }
        }

        if (device.getName().contains(targetBluetoothName)) {
            if (!connected) {
                    getCurrentLocation(context, targetName);
                }
            if (!isInsideGeofence) {
                
                showNotification(context, device.getName(), connected, targetSound);
            } else {
                Log.d("BluetoothReceiver", "Inside geofence → skipping notification");
            }
        }
    }

    private void getCurrentLocation(Context context, String targetName) {
        FusedLocationProviderClient fusedLocationClient = LocationServices.getFusedLocationProviderClient(context);
        if (!hasRequiredPermissions(context)) {
            Log.e("BluetoothReceiver", "❌ Location permission not granted");
            return;
        }

        fusedLocationClient.getLastLocation()
                .addOnSuccessListener(location -> {
                    if (location != null) {
                        saveCurrentLocation(context, location, targetName);
                    } else {
                        Log.d("BluetoothReceiver", "❌ No last known location available.");
                    }
                });
    }

    private void saveCurrentLocation(Context context, Location location, String targetName) {
        try {
            SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
            JSONObject locObj = new JSONObject();
            locObj.put("lat", location.getLatitude());
            locObj.put("lng", location.getLongitude());
            locObj.put("time", System.currentTimeMillis());
            locObj.put("name", targetName);

            String existingLocationsJson = prefs.getString("flutter.currentLocation", "[]");
            JSONArray locationsArray = new JSONArray(existingLocationsJson);
            locationsArray.put(locObj);

            prefs.edit().putString("flutter.currentLocation", locationsArray.toString()).apply();
            Log.d("BluetoothReceiver", "📌 Saved current location: " + locObj.toString());
        } catch (JSONException e) {
            Log.e("BluetoothReceiver", "Failed to save location: " + e.getMessage());
        }
    }

    private void showNotification(Context context, String deviceName, boolean connected, String targetSound) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationManager.deleteNotificationChannel(CHANNEL_ID);
            NotificationChannel channel = new NotificationChannel(
                    CHANNEL_ID,
                    "Bluetooth Events",
                    NotificationManager.IMPORTANCE_HIGH
            );
            channel.setDescription("Notifications for Bluetooth events");
            channel.enableLights(true);
            channel.setLightColor(Color.BLUE);
            channel.enableVibration(true);

            if (targetSound != null && !targetSound.isEmpty()) {
                Uri soundUri = Uri.parse(targetSound);
                AudioAttributes audioAttributes = new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build();
                channel.setSound(soundUri, audioAttributes);
            }

            notificationManager.createNotificationChannel(channel);
        }

        Intent intent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
        if (intent != null) intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);

        PendingIntent pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent != null ? intent : new Intent(),
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
        );

        String title = connected ? "Exiting The Parking" : "PartAlert is Activated";
        String text = deviceName + (connected ? " connected!" : " disconnected!");

        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(context.getApplicationInfo().icon)
                .setContentTitle(title)
                .setContentText(text)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent);

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            if (targetSound != null && !targetSound.isEmpty()) {
                builder.setSound(Uri.parse(targetSound));
            } else {
                builder.setDefaults(NotificationCompat.DEFAULT_ALL);
            }
        }

        notificationManager.notify(1, builder.build());
    }
}
