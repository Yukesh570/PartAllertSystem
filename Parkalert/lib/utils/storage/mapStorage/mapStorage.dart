import 'dart:math';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Add this method to serialize polygons:

String encodePolygons(Set<Polygon> polygons) {
  final List<Map<String, dynamic>> polygonList = polygons.map((polygon) {
    return {
      'polygonId': polygon.polygonId.value,
      'points': polygon.points
          .map((point) => {'lat': point.latitude, 'lng': point.longitude})
          .toList(),
      'fillColor': polygon.fillColor.value,
      'strokeColor': polygon.strokeColor.value,
      'strokeWidth': polygon.strokeWidth,
    };
  }).toList();
  return jsonEncode(polygonList);
}

// Add this method to deserialize polygons:
Set<Polygon> decodePolygons(String polygonsJson) {
  final List<dynamic> polygonsList = jsonDecode(polygonsJson);
  return polygonsList.map<Polygon>((polyMap) {
    List<LatLng> points = (polyMap['points'] as List)
        .map((p) => LatLng(p['lat'], p['lng']))
        .toList();
    return Polygon(
      polygonId: PolygonId(polyMap['polygonId']),
      points: points,
      fillColor: Color(polyMap['fillColor']),
      strokeColor: Color(polyMap['strokeColor']),
      strokeWidth: polyMap['strokeWidth'],
    );
  }).toSet();
}
