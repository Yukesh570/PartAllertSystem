package com.parkAlert.Parkalert
import com.parkAlert.Parkalert.BluetoothReceiver
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val BLUETOOTH_CHANNEL = "bluetooth/events"
    private val GEOFENCE_CHANNEL = "geofence/events"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val bluetoothChannel  = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BLUETOOTH_CHANNEL)

        // Assign the MethodChannel instance to the static field in BluetoothReceiver
        BluetoothReceiver.channel = bluetoothChannel

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

    }
}
