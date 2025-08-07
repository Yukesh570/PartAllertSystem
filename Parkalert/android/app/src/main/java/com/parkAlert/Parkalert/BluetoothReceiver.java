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

import android.bluetooth.BluetoothDevice;

import io.flutter.plugin.common.MethodChannel;
import org.json.JSONObject;
import org.json.JSONException;
public class BluetoothReceiver extends BroadcastReceiver {
    public static final String CHANNEL_ID = "bluetooth_channel";
   

    
    // 👇 Add this line
    public static MethodChannel channel;

    @Override
    public void onReceive(Context context, Intent intent) {
        if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(intent.getAction())) {
            BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);

            SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
            String jsonString = prefs.getString("flutter.activeBluetooth", "");
            String targetBluetoothName = "";
            String targetSound = "";

            if (!jsonString.isEmpty()) {
                try{
                    JSONObject jsonObject = new JSONObject(jsonString);
                    targetBluetoothName = jsonObject.optString("bluetooth","");
                    targetSound=jsonObject.optString("sound","");   
                } catch (JSONException e) {
                        Log.e("BluetoothReceiver", "Failed to parse JSON: " + e.getMessage());
                }
            }
            if (device == null || targetBluetoothName.isEmpty()) {
                Log.d("BluetoothReceiver", "BluetoothDevice is null");
                return;
            }

            String deviceName = device.getName();
            if (deviceName == null) {
                Log.d("BluetoothReceiver", "device.getName() is null");
            } else {
                Log.d("BluetoothReceiver", "===Connected to: " + deviceName);
                Log.d("BluetoothReceiver", "===targetBluetoothName to: " + targetBluetoothName);

            }

            if (device != null && device.getName() != null && device.getName().contains(targetBluetoothName)) {
                // Notify Flutter if flutter app is active
                 Log.d("BluetoothReceiver", "Connected to: ");
                if (channel != null) {
                    channel.invokeMethod("onGalaxyBudsConnected", null);
                }
                else
                // Show native notification when flutter app is not active
                {showNotification(context,targetBluetoothName,targetSound);}
            }
            else {
                Log.d("BluetoothReceiver", "Did not match");
            }
        }
    }

            private void showNotification(Context context,String deviceName,String targetSound) {
                NotificationManager notificationManager = 
                    (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    NotificationChannel channel = new NotificationChannel(
                        CHANNEL_ID,
                        "Bluetooth Events",
                        NotificationManager.IMPORTANCE_HIGH
                    );
                    channel.setDescription("Notifications for Bluetooth events");
                    channel.enableLights(true);
                    channel.setLightColor(Color.BLUE);
                    channel.enableVibration(true);
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

                NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(context.getApplicationInfo().icon)
                    .setContentTitle("Bluetooth 0000Connected")
                    .setContentText(deviceName +" connected!")
                    .setPriority(NotificationCompat.PRIORITY_HIGH)
                    .setAutoCancel(true)
                    .setContentIntent(pendingIntent)
                    .setDefaults(NotificationCompat.DEFAULT_ALL);

                notificationManager.notify(1, builder.build());
            }
}
