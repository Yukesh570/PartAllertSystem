class RingerData {
  final int index;
  final String date;
  final String time;
  final bool isOn;

  RingerData({
    required this.index,
    required this.date,
    required this.time,
    required this.isOn,
  });

  Map<String, dynamic> toJson() => {
    'index': index,
    'date': date,
    'time': time,
    'isOn': isOn,
  };
  factory RingerData.fromJson(Map<String, dynamic> json) => RingerData(
    index: json['index'],
    date: json['date'],
    time: json['time'],
    isOn: json['isOn'],
  );
}
