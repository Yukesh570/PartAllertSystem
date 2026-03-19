import Foundation
import CoreBluetooth
import CoreLocation
import UserNotifications
import Flutter
import UIKit

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate {
    static let shared = BluetoothManager()
    
    private var centralManager: CBCentralManager!
    private var methodChannel: FlutterMethodChannel?
    private var connectedPeripherals: [UUID: CBPeripheral] = [:]
    
    // For fetching location on BLE event
    private let locationManager = CLLocationManager()
    private var pendingLocationTargetName: String?
    private var pendingLocationConnected: Bool = false
    private var bgTask: UIBackgroundTaskIdentifier = .invalid

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func setMethodChannel(_ channel: FlutterMethodChannel?) {
        self.methodChannel = channel
    }
    
    func startScanning() {
        if centralManager.state == .poweredOn {
            // Note: Background scanning requires explicit Service UUIDs in production
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn { startScanning() }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let advName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let deviceName = advName ?? peripheral.name ?? ""
        
        // Connect to any device we discover so we can get connect/disconnect events
        if !deviceName.isEmpty {
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let deviceName = peripheral.name ?? "Unknown"
        connectedPeripherals[peripheral.identifier] = peripheral
        print("Bluetooth connected: \(deviceName)")
        
        handleBluetoothEvent(deviceName: deviceName, isConnecting: true)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let deviceName = peripheral.name ?? "Unknown"
        connectedPeripherals.removeValue(forKey: peripheral.identifier)
        print("Bluetooth disconnected: \(deviceName)")
        
        handleBluetoothEvent(deviceName: deviceName, isConnecting: false)
        startScanning()
    }
    
    // MARK: - Logic Match with Android
    private func handleBluetoothEvent(deviceName: String, isConnecting: Bool) {
        // Request background execution time (simulates Android's 10s foreground service)
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.bgTask)
            self.bgTask = .invalid
        })
        
        // 1. Get Matching Ringer
        guard let ringerJsonString = getMatchingRinger(deviceName: deviceName, isConnecting: isConnecting),
              let ringerData = ringerJsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: ringerData, options: []) as? [String: Any] else {
            UIApplication.shared.endBackgroundTask(self.bgTask)
            return
        }
        
        let targetName = jsonObject["name"] as? String ?? ""
        let targetSound = jsonObject["sound"] as? String ?? ""
        let targetVibration = jsonObject["vibration"] as? String ?? "true"
        
        // 2. Temporarily wake up Geofence manager
        GeofenceManager.shared.startTemporaryTracking()
        
        // Delay by 2 seconds to allow Geofence to update (Matching Android Handler delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let isInsideGeofence = UserDefaults.standard.bool(forKey: "flutter.insideGeofence")
            
            self.getCurrentLocation(targetName: targetName, connected: isConnecting)
            
            if !isInsideGeofence {
                self.showNotification(deviceName: deviceName, targetName: targetName, connected: isConnecting, targetSound: targetSound, targetVibration: targetVibration)
            } else {
                print("Inside geofence → skipping notification")
            }
        }
    }
    
    private func getMatchingRinger(deviceName: String, isConnecting: Bool) -> String? {
        let prefs = UserDefaults.standard
        
        // Flutter saves arrays as [String] in iOS UserDefaults
        if let rawArray = prefs.stringArray(forKey: "flutter.ringers") {
            for item in rawArray {
                if isFullMatch(jsonString: item, deviceName: deviceName, isConnecting: isConnecting) {
                    return item
                }
            }
        } else if let rawString = prefs.string(forKey: "flutter.ringers") {
            // Fallback for weird string encoding
            if isFullMatch(jsonString: rawString, deviceName: deviceName, isConnecting: isConnecting) {
                return rawString
            }
        }
        return nil
    }
    
    private func isFullMatch(jsonString: String, deviceName: String, isConnecting: Bool) -> Bool {
        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return false }
        
        let targetBluetooth = json["bluetooth"] as? String ?? ""
        let triggerType = json["triggerType"] as? String ?? "Connect"
        
        let nameMatches = !targetBluetooth.isEmpty && deviceName.contains(targetBluetooth)
        if !nameMatches { return false }
        
        let triggerMatches = (triggerType.lowercased() == "connect" && isConnecting) ||
                             (triggerType.lowercased() == "disconnect" && !isConnecting)
        
        return triggerMatches
    }
    
    // MARK: - Location & Notification
    private func getCurrentLocation(targetName: String, connected: Bool) {
        self.pendingLocationTargetName = targetName
        self.pendingLocationConnected = connected
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, let targetName = pendingLocationTargetName else { return }
        
        let locObj: [String: Any] = [
            "lat": location.coordinate.latitude,
            "lng": location.coordinate.longitude,
            "time": Int(Date().timeIntervalSince1970 * 1000),
            "name": targetName,
            "status": pendingLocationConnected ? "Connected" : "Disconnected"
        ]
        
        saveCurrentLocation(locObj: locObj)
        self.pendingLocationTargetName = nil
        
        if bgTask != .invalid {
            UIApplication.shared.endBackgroundTask(bgTask)
            bgTask = .invalid
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location fetch failed: \(error)")
    }
    
    private func saveCurrentLocation(locObj: [String: Any]) {
        let prefs = UserDefaults.standard
        
        do {
            let newJsonData = try JSONSerialization.data(withJSONObject: locObj, options: [])
            let newJsonString = String(data: newJsonData, encoding: .utf8)!
            
            // Append to existing array
            var currentArr = prefs.stringArray(forKey: "flutter.currentLocation") ?? []
            currentArr.append(newJsonString)
            prefs.set(currentArr, forKey: "flutter.currentLocation")
            
            var backupArr = prefs.stringArray(forKey: "flutter.backupcurrentLocation") ?? []
            backupArr.append(newJsonString)
            prefs.set(backupArr, forKey: "flutter.backupcurrentLocation")
            
        } catch {
            print("Failed to save location history")
        }
    }
    
    private func showNotification(deviceName: String, targetName: String, connected: Bool, targetSound: String, targetVibration: String) {
        let content = UNMutableNotificationContent()
        content.title = connected ? targetName : targetName
        content.body = "\(deviceName) \(connected ? "connected!" : "disconnected!")"
        
        if targetSound.isEmpty {
            content.sound = UNNotificationSound.default
        } else {
            // Make sure your .wav files are added to the iOS project target!
            let soundName = UNNotificationSoundName(rawValue: "\(targetSound).wav")
            content.sound = UNNotificationSound(named: soundName)
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let e = error { print("Notification error: \(e)") }
        }
    }
}