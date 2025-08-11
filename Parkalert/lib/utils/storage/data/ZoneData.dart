class ZoneData {
  int index;
  String initialTime;
  String stopTime;
  bool isOn;
  String name;

  ZoneData({
    required this.index,
    required this.initialTime,
    required this.stopTime,
    required this.isOn,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'index': index,
    'initialTime': initialTime,
    'stopTime': stopTime,
    'isOn': isOn,
    'name': name,
  };
  factory ZoneData.fromJson(Map<String, dynamic> json) => ZoneData(
    index: json['index'] ?? 0,
    initialTime: json['initialTime'] ?? '',
    stopTime: json['stopTime'] ?? '',
    isOn: json['isOn'] ?? false,
    name: json['name'] ?? '',
  );

  void map(Set<void> Function(dynamic r) param0) {}
}
