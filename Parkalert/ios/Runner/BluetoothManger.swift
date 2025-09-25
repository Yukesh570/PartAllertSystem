import Foundation
import CoreBluetooth
import UserNotifications
import Flutter
import CoreLocation

final class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BluetoothManager()

    private var central: CBCentralManager!
    private var connectedPeripherals: [CBPeripheral] = []
    private var targetName: String?
    private var channel: FlutterMethodChannel?
    private let notificationCenter = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil, options: nil)
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in }
    }

    func setMethodChannel(_ channel: FlutterMethodChannel?) {
        self.channel = channel
    }

    func setTargetName(_ name: String?) {
        self.targetName = name
    }

    // Start scanning
    func startScanning() {
        guard central.state == .poweredOn else { return }
        // Best practice: scan for specific service UUIDs if you have them.
        // For name-based scanning (less reliable in background):
        central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stopScanning() {
        central.stopScan()
    }

    // CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("BLE powered on")
            // Optionally auto-start scanning
            // startScanning()
        default:
            print("BLE state: \(central.state.rawValue)")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Find name in advertisement or peripheral
        let advName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
        let name = advName ?? peripheral.name

        guard let target = targetName, !target.isEmpty else { return }

        if let name = name, name.contains(target) {
            print("Found target peripheral: \(name)")
            // Option: notify Flutter about discovery
            channel?.invokeMethod("bluetoothDiscovered", arguments: ["name": name, "rssi": RSSI.intValue])

            // Try to connect for connect/disconnect callbacks
            peripheral.delegate = self
            central.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to: \(peripheral.name ?? "unknown")")
        connectedPeripherals.append(peripheral)
        channel?.invokeMethod("bluetoothConnected", arguments: peripheral.name ?? "unknown")
        sendLocalNotification(title: "Bluetooth Connected", body: peripheral.name ?? "device")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from: \(peripheral.name ?? "unknown")")
        if let idx = connectedPeripherals.firstIndex(where: { $0.identifier == peripheral.identifier }) {
            connectedPeripherals.remove(at: idx)
        }
        channel?.invokeMethod("bluetoothDisconnected", arguments: peripheral.name ?? "unknown")
        sendLocalNotification(title: "Bluetooth Disconnected", body: peripheral.name ?? "device")
    }

    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        notificationCenter.add(req) { error in if let e = error { print(e) } }
    }

    // Optional CBPeripheralDelegate methods if you need services/characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // ...
    }
}
