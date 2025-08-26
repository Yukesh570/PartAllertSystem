package com.parkAlert.Parkalert;
import android.location.Location;
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
import android.preference.PreferenceManager;

import androidx.core.app.NotificationCompat;
import android.util.Log;
import android.media.AudioAttributes;
import android.net.Uri;
import android.bluetooth.BluetoothDevice;

import io.flutter.plugin.common.MethodChannel;
import org.json.JSONObject;
import org.json.JSONException;
import org.json.JSONArray;

public class BluetoothReceiver extends BroadcastReceiver {
    public static final String CHANNEL_ID = "bluetooth_channel";
   

    
    // 👇 Add this line
    public static MethodChannel channel;
 
    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();

        if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) {
            Log.e("BluetoothReceiver", "ACTION_ACL_CONNECTED -=-=-=-=-=-=-=-=-=-=-=-=-=-=-");


            BluetoothDevice device =intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
            handleBluetoothEvent(context, device, true);
        }
        else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
            Log.e("BluetoothReceiver", "ACTION_ACL_DISCONNECTED -=-=-=-=-=-=-=-=-=-=-=-=-=-=-");

            BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
            handleBluetoothEvent(context, device, false);
        }
    }
    private void getCurrentLocation(Context context, String targetName) {
    FusedLocationProviderClient fusedLocationClient =
            LocationServices.getFusedLocationProviderClient(context);

    if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) 
            != PackageManager.PERMISSION_GRANTED &&
        ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) 
            != PackageManager.PERMISSION_GRANTED) {
        Log.e("BluetoothReceiver", "❌ Location permission not granted");
        return;
    }

    fusedLocationClient.getLastLocation()
            .addOnSuccessListener(location -> {
                if (location != null) {
                    saveCurrentLocation(context, location,targetName);
                } else {
                    Log.d("BluetoothReceiver", "❌ No last known location available.");
                }
            });
    }

    private void saveCurrentLocation(Context context, Location location,String targetName) {
    try {
        // Flutter SharedPreferences uses a different storage mechanism
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        
        JSONObject locObj = new JSONObject();
        locObj.put("lat", location.getLatitude());
        locObj.put("lng", location.getLongitude());
        locObj.put("time", System.currentTimeMillis());
        locObj.put("name", targetName); // 👈 add device name here

            // Get existing locations list from the SAME key
        String existingLocationsJson = prefs.getString("flutter.currentLocation", "[]");
        JSONArray locationsArray = new JSONArray(existingLocationsJson);

        locationsArray.put(locObj);
        String locationString = locationsArray.toString();

        
        // Flutter uses a specific format: "flutter." prefix and specific encoding
        SharedPreferences.Editor editor = prefs.edit();
        editor.putString("flutter.currentLocation", locationString);
        editor.apply();
        
        Log.d("BluetoothReceiver", "📌 Saved current location: " + locationString);
        
        // Verify it was saved correctly
        String savedValue = prefs.getString("flutter.currentLocation", "");
        Log.d("BluetoothReceiver", "📌 Verify save - retrieved: " + savedValue);
        
    } catch (JSONException e) {
        Log.e("BluetoothReceiver", "Failed to save location: " + e.getMessage());
    }
}


    private void handleBluetoothEvent(Context context, BluetoothDevice device, boolean connected) {
            SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
                        String jsonString = prefs.getString("flutter.activeBluetooth", "");
                        boolean isInsideGeofence = prefs.getBoolean("flutter.insideGeofence", false);
                        String targetBluetoothName = "";
                        String targetSound = "";
                        String targetName = "";
                Log.d("BluetoothReceiver", "12121212121212121212insideGeofence6969696996969696969696696969: " + isInsideGeofence);

                if (!jsonString.isEmpty()) {
                    try {
                        JSONObject jsonObject = new JSONObject(jsonString);
                        targetBluetoothName = jsonObject.optString("bluetooth", "");
                        targetSound = jsonObject.optString("sound", "");
                        targetName =jsonObject.optString("name", "");
                        Log.d("BluetoothReceiver", "Target Bluetooth name===++++++++++++===: " + targetName);

                    } catch (JSONException e) {
                        Log.e("BluetoothReceiver", "Failed to parse JSON: " + e.getMessage());
                    }
                }
                if (device == null || targetBluetoothName.isEmpty()) {
                    Log.d("BluetoothReceiver", "BluetoothDevice is null or no target Bluetooth configured");
                    return;
                }

                String deviceName = device.getName();
                if (deviceName == null) {
                    Log.d("BluetoothReceiver", "device.getName() is null");
                    return;
                }
                Log.d("BluetoothReceiver", (connected ? "Connected to: " : "Disconnected from: ") + deviceName);
                Log.d("BluetoothReceiver", "Target Bluetooth name======: " + targetBluetoothName);

                if (deviceName.contains(targetBluetoothName)) 
        {
                if (!isInsideGeofence) {
                // if (channel != null) {
                //     String methodName = connected ? "onGalaxyBudsConnected" : "onGalaxyBudsDisconnected";
                //     channel.invokeMethod(methodName, null);
                // } 
                // else  
                // {
                if (!connected) {
                    getCurrentLocation(context,targetName); // pass context!
                }
                                Log.d("BluetoothReceiver", "BEEEEEEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFOOOOOOOOOOOOOOOORRRRRRRRRRRRRRRREEEEEEEEEEE");

                showNotification(context, deviceName, connected, targetSound);
                                Log.d("BluetoothReceiver", "aaaaaaaaaaaaaaFFFFFFFFFFFFFFFFFFFTTTTTTTTTTTTTTTTTTTEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRR");

                // }                
            } 
                else {
                Log.d("BluetoothReceiver", "Inside geofence → skipping notification");
            }
                // Notify Flutter if flutter app is active
               
        }
             else {
                Log.d("BluetoothReceiver", "Device name does not match target Bluetooth");
            }
        }
    

 
private void showNotification(Context context, String deviceName, boolean connected, String targetSound) {
    NotificationManager notificationManager =
        (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    Log.d("BluetoothReceiver", "aaaaaaaaaaaaaaFFFFFFFFFFFFFFFF121212121222222222222222222222222222222FFFTTTTTTTTTTTTTTTTTTTEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRR");

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        // Always delete existing channel so sound updates
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

        // Set custom sound if provided
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
    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);

    PendingIntent pendingIntent = PendingIntent.getActivity(
        context,
        0,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
    );
    Log.d("BluetoothReceiver", "aaaaaaaaaaaaaaFFFFFFFFFFFFFFFFFFFTT0000000000000000000000000000000000000000000000TTTTTTTTTTTTTTTTTEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRR");

    String title = connected ? "Bluetooth ConnectedDDD" : "Bluetooth Disconnectedddd";
    String text = deviceName + (connected ? " connected!" : " disconnected!");

    NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
        .setSmallIcon(context.getApplicationInfo().icon)
        .setContentTitle(title)
        .setContentText(text)
        .setPriority(NotificationCompat.PRIORITY_HIGH)
        .setAutoCancel(true)
        .setContentIntent(pendingIntent);

    // Set sound for pre-Oreo devices
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
        if (targetSound != null && !targetSound.isEmpty()) {
            Uri soundUri = Uri.parse(targetSound);
            builder.setSound(soundUri);
        } else {
            builder.setDefaults(NotificationCompat.DEFAULT_ALL);
        }
    }

    notificationManager.notify(1, builder.build());
}


}
 // public void onReceive(Context context, Intent intent) {
    //     if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(intent.getAction())) {
    //         BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);

    //         SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
    //         String jsonString = prefs.getString("flutter.activeBluetooth", "");
    //         String targetBluetoothName = "";
    //         String targetSound = "";

    //         if (!jsonString.isEmpty()) {
    //             try{
    //                 JSONObject jsonObject = new JSONObject(jsonString);
    //                 targetBluetoothName = jsonObject.optString("bluetooth","");
    //                 targetSound=jsonObject.optString("sound","");   
    //             } catch (JSONException e) {
    //                     Log.e("BluetoothReceiver", "Failed to parse JSON: " + e.getMessage());
    //             }
    //         }
    //         if (device == null || targetBluetoothName.isEmpty()) {
    //             Log.d("BluetoothReceiver", "BluetoothDevice is null");
    //             return;
    //         }

    //         String deviceName = device.getName();
    //         if (deviceName == null) {
    //             Log.d("BluetoothReceiver", "device.getName() is null");
    //         } else {
    //             Log.d("BluetoothReceiver", "===Connected to: " + deviceName);
    //             Log.d("BluetoothReceiver", "===targetBluetoothName to: " + targetBluetoothName);

    //         }

    //         if (device != null && device.getName() != null && device.getName().contains(targetBluetoothName)) {
    //             // Notify Flutter if flutter app is active
    //              Log.d("BluetoothReceiver", "Connected to: ");
    //             if (channel != null) {
    //                 channel.invokeMethod("onGalaxyBudsConnected", null);
    //             }
    //             else
    //             // Show native notification when flutter app is not active
    //             {showNotification(context,targetBluetoothName,targetSound);}
    //         }
    //         else {
    //             Log.d("BluetoothReceiver", "Did not match");
    //         }
    //     }
    // }