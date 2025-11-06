class Historydata {
  int index;
  double lat;
  double lng;
  String time;
  String name;
  String? status;

  Historydata({
    required this.index,

    required this.lat,
    required this.lng,
    required this.time,
    required this.name,
    this.status,
  });

  Map<String, dynamic> toJson() => {
    'index': index,

    'lat': lat,
    'lng': lng,
    'time': time,
    'name': name,
    'status': status ?? '',
  };

  factory Historydata.fromJson(Map<String, dynamic> json) => Historydata(
    index: json['index'] ?? 0,

    lat: (json['lat'] ?? 0).toDouble(),
    lng: (json['lng'] ?? 0).toDouble(),
    time: json['time'] ?? '',
    name: json['name'] ?? '',
    status: json['status'] ?? '',
  );
  @override
  String toString() {
    return "Historydata(index: $index, lat: $lat, lng: $lng, time: $time, name: $name,status: ${status ?? ''})";
  }
}
