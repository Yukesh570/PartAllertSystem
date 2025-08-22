package com.parkAlert.Parkalert;

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
public class BluetoothReceiver extends BroadcastReceiver {
    public static final String CHANNEL_ID = "bluetooth_channel";
   

    
    // 👇 Add this line
    public static MethodChannel channel;
    public static boolean insideGeofence = false;
    public static void updateGeofenceState(boolean inside) {
        insideGeofence = inside;
        Log.d("BluetoothReceiver", "Live geofence state updated = " + inside);
    }
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
    private void handleBluetoothEvent(Context context, BluetoothDevice device, boolean connected) {
            SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
                        boolean insideGeofence = BluetoothReceiver.insideGeofence;
                        String jsonString = prefs.getString("flutter.activeBluetooth", "");
                        String targetBluetoothName = "";
                        String targetSound = "";
                if (!jsonString.isEmpty()) {
                    try {
                        JSONObject jsonObject = new JSONObject(jsonString);
                        targetBluetoothName = jsonObject.optString("bluetooth", "");
                        targetSound = jsonObject.optString("sound", "");
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
                Log.d("BluetoothReceiver", "insideGeofence: " + insideGeofence);

                if (deviceName.contains(targetBluetoothName)) 
        {
                if (!insideGeofence) {
                        if (channel != null) {
                    String methodName = connected ? "onGalaxyBudsConnected" : "onGalaxyBudsDisconnected";
                    channel.invokeMethod(methodName, null);
                } else  {
                showNotification(context, deviceName, connected, targetSound);
            }                } 
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

    String title = connected ? "Bluetooth Connected" : "Bluetooth Disconnected";
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