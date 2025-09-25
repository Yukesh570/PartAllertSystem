import Foundation
import CoreLocation
import UserNotifications
import Flutter

final class GeofenceManager: NSObject, CLLocationManagerDelegate {
    static let shared = GeofenceManager()
    private let locationManager = CLLocationManager()
    private var channel: FlutterMethodChannel?

    // state
    private var isInsideZone = false
    private let notificationCenter = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1 // meters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        // Request notification permission
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in }
    }

    func setMethodChannel(_ channel: FlutterMethodChannel?) {
        self.channel = channel
    }

    // Call this from Flutter (or native) to request permissions
    func requestPermissions() {
        // Request "when in use" then ask for Always authorization
        locationManager.requestWhenInUseAuthorization()
        // If you already have WhenInUse, ask for Always:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    // Start monitoring zones (zonesData is expected as [[String:Any]] from Flutter)
    // Each zone could be: { "name": "Zone 1", "isOn": true, "points":[ { "lat":..,"lng":.. }, ... ] }
    func updateZones(_ zonesData: [[String:Any]]) {
        // Stop previous updates
        locationManager.stopUpdatingLocation()
        // We'll monitor location updates for polygon membership; optionally set circular monitors too
        locationManager.startUpdatingLocation()
        // Save zones to memory
        self.zones = zonesData
    }

    private var zones: [[String:Any]] = []

    // CoreLocation delegate:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        checkGeofences(location: loc)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("GeofenceManager: Always authorized")
        case .authorizedWhenInUse:
            print("GeofenceManager: WhenInUse authorized (consider requesting Always)")
        default:
            print("GeofenceManager: Authorization changed: \(status.rawValue)")
        }
    }

    private func checkGeofences(location: CLLocation) {
        // Convert zones to polygon arrays and check if inside any active zone
        var insideAny = false
        var activeName: String? = nil

        for zone in zones {
            guard let isOn = zone["isOn"] as? Bool, isOn else { continue }
            guard let name = zone["name"] as? String else { continue }
            guard let points = zone["points"] as? [[String:Any]], points.count >= 3 else { continue }

            // Build array of (lat, lng)
            let polygon = points.compactMap { (p) -> (Double,Double)? in
                if let lat = p["lat"] as? Double, let lng = p["lng"] as? Double {
                    return (lat,lng)
                }
                return nil
            }
            if pointInPolygon(lat: location.coordinate.latitude, lon: location.coordinate.longitude, polygon: polygon) {
                insideAny = true
                activeName = name
                break
            }

            // Optional: near-edge check (compute min distance to edges) could be added
        }

        if insideAny && !isInsideZone {
            // entered
            isInsideZone = true
            sendLocalNotification(title: "Entered Zone", body: activeName ?? "zone")
            channel?.invokeMethod("enteredZone", arguments: activeName ?? "zone")
        } else if !insideAny && isInsideZone {
            // exited
            isInsideZone = false
            sendLocalNotification(title: "Exited Zone", body: "geofenced area")
            channel?.invokeMethod("exitedZone", arguments: "geofenced area")
        }

        // Persist state in UserDefaults (FlutterSharedPreferences equivalent)
        UserDefaults.standard.set(isInsideZone, forKey: "flutter.insideGeofence")
    }

    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        notificationCenter.add(req) { error in
            if let err = error { print("Notification error: \(err)") }
        }
    }

    // Ray-casting point-in-polygon
    private func pointInPolygon(lat: Double, lon: Double, polygon: [(Double,Double)]) -> Bool {
        var inside = false
        var j = polygon.count - 1
        for i in 0..<polygon.count {
            let xi = polygon[i].0, yi = polygon[i].1
            let xj = polygon[j].0, yj = polygon[j].1
            let intersect = ((yi > lon) != (yj > lon)) &&
                (lat < (xj - xi) * (lon - yi) / (yj - yi + 0.0) + xi)
            if intersect {
                inside = !inside
            }
            j = i
        }
        return inside
    }
}
