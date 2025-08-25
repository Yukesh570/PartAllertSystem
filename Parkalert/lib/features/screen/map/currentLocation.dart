import 'dart:async';
import 'dart:math';
import 'dart:math' as math;

import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeofenceService {
  static const double _distanceFilter = 1.0; // meters (reduced from 10)
  static const double _edgeBuffer = 2.0; // meters buffer for boundary detection
  StreamSubscription<Position>? _positionStream;
  bool _isInsideZone = false;
  final Function(String, String) showNotification;
  final VoidCallback updateState;

  GeofenceService({required this.showNotification, required this.updateState});
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    if (polygon.isEmpty) return false;
    if (polygon.length < 3) return false; // Not a valid polygon

    // 1. First do a simple bounding box check
    double minX = polygon[0].latitude;
    double maxX = polygon[0].latitude;
    double minY = polygon[0].longitude;
    double maxY = polygon[0].longitude;

    for (final p in polygon) {
      minX = min(minX, p.latitude);
      maxX = max(maxX, p.latitude);
      minY = min(minY, p.longitude);
      maxY = max(maxY, p.longitude);
    }

    // Quick rejection if point is outside bounding box
    if (point.latitude < minX ||
        point.latitude > maxX ||
        point.longitude < minY ||
        point.longitude > maxY) {
      return false;
    }

    // 2. Ray casting algorithm
    bool inside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final LatLng vertex1 = polygon[j];
      final LatLng vertex2 = polygon[i];

      // Check if point is between the vertices in the y-direction
      final bool vertex1Above = vertex1.longitude > point.longitude;
      final bool vertex2Above = vertex2.longitude > point.longitude;

      if (vertex1Above != vertex2Above) {
        // Avoid division by zero for horizontal edges
        if (vertex1.longitude == vertex2.longitude) {
          continue;
        }

        // Calculate intersection point
        final double intersectionLat =
            (vertex2.latitude - vertex1.latitude) *
                (point.longitude - vertex1.longitude) /
                (vertex2.longitude - vertex1.longitude) +
            vertex1.latitude;

        // Check if point is to the left of the intersection
        if (point.latitude <= intersectionLat) {
          inside = !inside;
        }
      }
    }

    return inside;
  }

  void startMonitoring() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation, // More accurate positioning
      distanceFilter: 5,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _checkGeofence(LatLng(position.latitude, position.longitude));
          },
        );
  }

  void stopMonitoring() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  static const platform = MethodChannel('bluetooth/events');

  Future<void> _updateGeofenceState(bool inside) async {
    // print("Updating insideGeofencekkkkkkkkkkkkkkkkkkkkkkkkkkkkkk = $inside");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("flutter.insideGeofence", inside);
    await prefs.reload(); // make sure it's flushed
    // await platform.invokeMethod("updateGeofenceState", {"inside": inside});

    print("Updated insideGeofence = $inside");
  }

  Future<void> _checkGeofence(LatLng currentLocation) async {
    List<ZoneData> zones = await loadZones();
    bool insideAnyZone = false;
    String? activeZoneName;

    for (var zone in zones) {
      if (!zone.isOn) continue;
      List<LatLng> polygonPoints = zone.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      if (_isPointInPolygon(currentLocation, polygonPoints) ||
          _isNearPolygonEdge(currentLocation, polygonPoints, _edgeBuffer)) {
        insideAnyZone = true;
        activeZoneName = zone.name;
        break; // ✅ found a zone, no need to keep checking
      }
    }

    // ✅ Handle enter
    if (insideAnyZone && !_isInsideZone) {
      await _showZoneNotification(
        "Entered yukesh Zone",
        activeZoneName ?? "zone",
      );
      await _updateGeofenceState(true);
    }

    // ✅ Handle exit
    if (!insideAnyZone && _isInsideZone) {
      await _showZoneNotification("Exited yukesh Zone", "geofenced area");
      await _updateGeofenceState(false);
    }

    // Update state tracking
    _isInsideZone = insideAnyZone;
    updateState();
  }

  void dispose() {
    stopMonitoring();
  }

  bool _isNearPolygonEdge(
    LatLng point,
    List<LatLng> polygon,
    double bufferMeters,
  ) {
    final Distance distance = Distance();

    for (int i = 0; i < polygon.length; i++) {
      final LatLng p1 = polygon[i];
      final LatLng p2 = polygon[(i + 1) % polygon.length];

      // Calculate distance from point to edge
      final double distToEdge = distance.distanceToLine(point, p1, p2);

      if (distToEdge <= bufferMeters) {
        return true;
      }
    }
    return false;
  }

  Future<void> _showZoneNotification(String title, String body) async {
    // Show both system notification and snackbar
    showNotification(title, "You've $body");
  }
}

class Distance {
  static const double earthRadius = 6371000; // meters

  double distanceToLine(LatLng point, LatLng lineStart, LatLng lineEnd) {
    // Convert to radians
    final double lat1Rad = lineStart.latitude * pi / 180;
    final double lat2Rad = lineEnd.latitude * pi / 180;
    final double lon1Rad = lineStart.longitude * pi / 180;
    final double lon2Rad = lineEnd.longitude * pi / 180;
    final double pointLatRad = point.latitude * pi / 180;
    final double pointLonRad = point.longitude * pi / 180;

    // Calculate the angular distance
    final double deltaLat = lat2Rad - lat1Rad;
    final double deltaLon = lon2Rad - lon1Rad;

    // Calculate the denominator for the projection
    final double denom =
        deltaLat * deltaLat + deltaLon * deltaLon * cos(lat1Rad) * cos(lat2Rad);
    if (denom == 0) {
      // Line is actually a point
      return distanceBetween(
        lineStart.latitude,
        lineStart.longitude,
        point.latitude,
        point.longitude,
      );
    }

    // Calculate the projection factor
    final double t =
        ((pointLatRad - lat1Rad) * deltaLat +
            (pointLonRad - lon1Rad) * deltaLon * cos(lat1Rad) * cos(lat2Rad)) /
        denom;

    if (t <= 0) {
      return distanceBetween(
        lineStart.latitude,
        lineStart.longitude,
        point.latitude,
        point.longitude,
      );
    } else if (t >= 1) {
      return distanceBetween(
        lineEnd.latitude,
        lineEnd.longitude,
        point.latitude,
        point.longitude,
      );
    } else {
      // Calculate projected point
      final double projectedLatRad = lat1Rad + t * deltaLat;
      final double projectedLonRad = lon1Rad + t * deltaLon;

      return distanceBetween(
        projectedLatRad * 180 / pi,
        projectedLonRad * 180 / pi,
        point.latitude,
        point.longitude,
      );
    }
  }

  double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    final double dLat = (lat2 - lat1) * pi / 180;
    final double dLon = (lon2 - lon1) * pi / 180;

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }
}
