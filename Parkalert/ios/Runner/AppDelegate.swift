import Flutter
import UIKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.parkalert/geofence_bt", binaryMessenger: controller.binaryMessenger)
    
    // Pass channel to both managers
    GeofenceManager.shared.setMethodChannel(channel)
    BluetoothManager.shared.setMethodChannel(channel)

    // ADD THIS: Listen for method calls from Flutter
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
        case "requestGeofencePermissions":
            GeofenceManager.shared.requestPermissions()
            result(nil)
        case "updateZones":
            if let args = call.arguments as? [[String: Any]] {
                GeofenceManager.shared.updateZones(args)
            }
            result(nil)
        case "setBluetoothTarget":
            if let args = call.arguments as? [String: Any], let name = args["name"] as? String {
                BluetoothManager.shared.setTargetName(name)
                BluetoothManager.shared.startScanning()
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
      
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}