import Foundation
import CoreLocation
import UserNotifications
import Flutter

class GeofenceManager: NSObject, CLLocationManagerDelegate {
    static let shared = GeofenceManager()
    
    private let locationManager = CLLocationManager()
    private var methodChannel: FlutterMethodChannel?
    
    private var isInsideZone = false
    private let edgeBufferMeters = 2.0
    
    struct LatLng {
        var lat: Double
        var lng: Double
    }
    
    struct Zone {
        var name: String
        var isOn: Bool
        var points: [LatLng]
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        // Distance filter simulates Android's 3-second smallestDisplacement
        locationManager.distanceFilter = 1.0 
    }

    func setMethodChannel(_ channel: FlutterMethodChannel?) {
        self.methodChannel = channel
    }
    
    func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
    }
    
    // Called by BluetoothManager to wake up the geofence checker temporarily
    func startTemporaryTracking() {
        locationManager.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - CoreLocation Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        checkGeofence(location: location)
    }
    
    private func checkGeofence(location: CLLocation) {
        let zones = loadZonesFromPrefs()
        var insideAnyZone = false
        var activeZoneName: String? = nil
        
        for zone in zones {
            if !zone.isOn || zone.points.count < 3 { continue }
            
            let insidePolygon = isPointInPolygon(lat: location.coordinate.latitude, lng: location.coordinate.longitude, polygon: zone.points)
            let nearEdge = isNearPolygonEdge(lat: location.coordinate.latitude, lng: location.coordinate.longitude, polygon: zone.points, bufferMeters: edgeBufferMeters)
            
            if insidePolygon || nearEdge {
                insideAnyZone = true
                activeZoneName = zone.name
                break
            }
        }
        
        if insideAnyZone && !isInsideZone {
            methodChannel?.invokeMethod("enteredZone", arguments: activeZoneName ?? "zone")
        } else if !insideAnyZone && isInsideZone {
            methodChannel?.invokeMethod("exitedZone", arguments: "geofenced area")
        }
        
        isInsideZone = insideAnyZone
        UserDefaults.standard.set(isInsideZone, forKey: "flutter.insideGeofence")
    }
    
    // MARK: - Data Loading & Parsing
    private func loadZonesFromPrefs() -> [Zone] {
        var zones: [Zone] = []
        let prefs = UserDefaults.standard
        var jsonString = prefs.string(forKey: "flutter.zones") ?? prefs.string(forKey: "zones")
        
        guard let dataStr = jsonString else { return zones }
        
        // Handle Flutter Prefix
        let flutterPrefix = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu!"
        if dataStr.hasPrefix(flutterPrefix) {
            jsonString = String(dataStr.dropFirst(flutterPrefix.count))
        }
        
        guard let jsonData = jsonString?.data(using: .utf8),
              let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] else {
            return zones
        }
        
        for item in jsonArray {
            let name = item["name"] as? String ?? "zone"
            let isOn = item["isOn"] as? Bool ?? false
            
            var points: [LatLng] = []
            if let pointsArray = item["points"] as? [[String: Double]] {
                for p in pointsArray {
                    if let lat = p["lat"], let lng = p["lng"] {
                        points.append(LatLng(lat: lat, lng: lng))
                    }
                }
            }
            zones.append(Zone(name: name, isOn: isOn, points: points))
        }
        return zones
    }
    
    // MARK: - Raycasting Algorithm
    private func isPointInPolygon(lat: Double, lng: Double, polygon: [LatLng]) -> Bool {
        if polygon.count < 3 { return false }
        var inside = false
        var j = polygon.count - 1
        
        for i in 0..<polygon.count {
            let pi = polygon[i]
            let pj = polygon[j]
            
            if (pi.lng > lng) != (pj.lng > lng) {
                let intersect = (pj.lat - pi.lat) * (lng - pi.lng) / (pj.lng - pi.lng) + pi.lat
                if lat < intersect {
                    inside = !inside
                }
            }
            j = i
        }
        return inside
    }
    
    // MARK: - Edge Buffer
    private func isNearPolygonEdge(lat: Double, lng: Double, polygon: [LatLng], bufferMeters: Double) -> Bool {
        let point = LatLng(lat: lat, lng: lng)
        for i in 0..<polygon.count {
            let p1 = polygon[i]
            let p2 = polygon[(i + 1) % polygon.count]
            if distanceToLine(point: point, start: p1, end: p2) <= bufferMeters {
                return true
            }
        }
        return false
    }
    
    private func distanceToLine(point: LatLng, start: LatLng, end: LatLng) -> Double {
        let x0 = point.lat, y0 = point.lng
        let x1 = start.lat, y1 = start.lng
        let x2 = end.lat, y2 = end.lng
        
        let A = x0 - x1
        let B = y0 - y1
        let C = x2 - x1
        let D = y2 - y1
        
        let dot = A * C + B * D
        let lenSq = C * C + D * D
        let param = lenSq != 0 ? dot / lenSq : -1
        
        var xx, yy: Double
        if param < 0 {
            xx = x1; yy = y1
        } else if param > 1 {
            xx = x2; yy = y2
        } else {
            xx = x1 + param * C; yy = y1 + param * D
        }
        
        let dx = x0 - xx
        let dy = y0 - yy
        return sqrt(dx * dx + dy * dy) * 111139 // degrees to meters approx
    }
}