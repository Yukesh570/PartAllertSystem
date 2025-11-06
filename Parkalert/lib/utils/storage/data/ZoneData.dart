import 'package:latlong2/latlong.dart';

class ZoneData {
  int index;
  String initialTime;
  String stopTime;
  bool isOn;
  String name;
  List<LatLng> points; // Polygon coordinates
  bool isSaved = false;

  ZoneData({
    required this.index,
    required this.initialTime,
    required this.stopTime,
    required this.isOn,
    required this.name,
    required this.points,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() => {
    'index': index,
    'initialTime': initialTime,
    'stopTime': stopTime,
    'isOn': isOn,
    'name': name,
    'points': points
        .map((p) => {'lat': p.latitude, 'lng': p.longitude})
        .toList(),

    'isSaved': isSaved,
  };
  factory ZoneData.fromJson(Map<String, dynamic> json) => ZoneData(
    index: json['index'] ?? 0,
    initialTime: json['initialTime'] ?? '',
    stopTime: json['stopTime'] ?? '',
    isOn: json['isOn'] ?? false,
    name: json['name'] ?? '',
    points: (json['points'] as List? ?? [])
        .map((p) => LatLng(p['lat'], p['lng']))
        .toList(),
    isSaved: json['isSaved'] ?? false,
  );

  void map(Set<void> Function(dynamic r) param0) {}
}
