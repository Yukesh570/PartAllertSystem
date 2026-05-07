package com.parkAlert.Parkalert

import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val BLUETOOTH_CHANNEL = "bluetooth/events"
    private val GEOFENCE_CHANNEL = "geofence/events"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BLUETOOTH_CHANNEL)
        BluetoothReceiver.channel = methodChannel

        // 1. Listen for Flutter telling Native to Snooze or Quit
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "snoozeFromFlutter" -> {
                    val intent = Intent(this, BluetoothReceiver::class.java)
                    intent.action = "ACTION_SNOOZE"
                    intent.putExtra("ringerJson", call.argument<String>("ringerJson"))
                    intent.putExtra("deviceName", call.argument<String>("deviceName"))
                    intent.putExtra("connected", call.argument<Boolean>("connected") ?: true)
                    intent.putExtra("notifId", 999)
                    sendBroadcast(intent)
                    result.success(true)
                }
                "quitFromFlutter" -> {
                    val intent = Intent(this, BluetoothReceiver::class.java)
                    intent.action = "ACTION_QUIT"
                    intent.putExtra("notifId", 999)
                    sendBroadcast(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // 2. Setup Geofence Channel
        val geofenceChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, GEOFENCE_CHANNEL)
        geofenceChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startGeofenceService" -> {
                    val intent = Intent(this, GeofenceForegroundService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success("Geofence service started")
                }
                "stopGeofenceService" -> {
                    val intent = Intent(this, GeofenceForegroundService::class.java)
                    stopService(intent)
                    result.success("Geofence service stopped")
                }
                else -> result.notImplemented()
            }
        }
        GeofenceForegroundService.channel = geofenceChannel

        // 3. Check if app was launched from a notification tap
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (intent.getBooleanExtra("from_notification", false)) {
            val args = mapOf(
                "ringerJson" to intent.getStringExtra("ringerJson"),
                "deviceName" to intent.getStringExtra("deviceName"),
                "connected" to intent.getBooleanExtra("connected", true)
            )
            
            // Send data to Flutter to show the popup!
            methodChannel?.invokeMethod("triggerAlarmPopup", args)
            
            // Remove extra so it doesn't trigger again on screen rotation
            intent.removeExtra("from_notification")
        }
    }
}