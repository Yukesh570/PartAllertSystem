class RingerData {
  int index;
  String date;
  String time;
  bool isOn;
  String name;
  String bluetooth;
  String sound;
  bool vibration;
  bool overRideSilence;
  String triggerType;

  RingerData({
    required this.index,
    required this.date,
    required this.time,
    required this.isOn,
    required this.name,
    required this.bluetooth,
    required this.sound,
    this.vibration = true,
    this.overRideSilence = false,
    required this.triggerType,
  });

  Map<String, dynamic> toJson() => {
    'index': index,
    'date': date,
    'time': time,
    'isOn': isOn,
    'name': name,
    'bluetooth': bluetooth,
    'sound': sound,
    'vibration': vibration,
    'overRideSilence': overRideSilence,
    'triggerType': triggerType,
  };
  factory RingerData.fromJson(Map<String, dynamic> json) => RingerData(
    index: json['index'] ?? 0,
    date: json['date'] ?? '',
    time: json['time'] ?? '',
    isOn: json['isOn'] ?? false,
    name: json['name'] ?? '',
    bluetooth: json['bluetooth'] ?? '',
    sound: json['sound'] ?? '',
    vibration: json['vibration'] ?? true,
    overRideSilence: json['overRideSilence'] ?? false,
    triggerType: json['triggerType'] ?? 'connect',
  );

  void map(Set<void> Function(dynamic r) param0) {}
}
