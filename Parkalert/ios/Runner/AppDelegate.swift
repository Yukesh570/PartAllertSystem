import Flutter
import UIKit
import flutter_local_notifications
import GoogleMaps // 1. ADD THIS IMPORT

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  
    // 2. ADD THIS LINE WITH YOUR ACTUAL GOOGLE MAPS API KEY
    GMSServices.provideAPIKey("AIzaSyDrUHqW414IFDi3RMRwy0en38XOvVrXD_Y")

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.parkalert/geofence_bt", binaryMessenger: controller.binaryMessenger)
    
    // Pass channel to both managers
    GeofenceManager.shared.setMethodChannel(channel)
    BluetoothManager.shared.setMethodChannel(channel)

    // Listen for method calls from Flutter
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
        case "requestGeofencePermissions":
            GeofenceManager.shared.requestPermissions()
            result(nil)
        case "updateZones":
            result(nil)
        case "setBluetoothTarget":
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