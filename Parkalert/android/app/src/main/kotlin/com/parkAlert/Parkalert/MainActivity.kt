package com.parkAlert.Parkalert
import com.parkAlert.Parkalert.BluetoothReceiver

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "bluetooth/events"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // Assign the MethodChannel instance to the static field in BluetoothReceiver
        BluetoothReceiver.channel = methodChannel
    }
}
