/// Device Sensor Reading model
class DeviceReading {
  double temp;
  double dust;
  int humi;
  int mq135;
  int mq4;
  int mq7;
  DateTime lastSeen;

  DeviceReading({
    required this.dust,
    required this.humi,
    required this.mq135,
    required this.mq4,
    required this.mq7,
    required this.temp,
    required this.lastSeen,
  });

  factory DeviceReading.fromMap(Map data) {
    return DeviceReading(
      temp: data['temp'] != null
          ? (data['temp'] % 1 == 0 ? data['temp'] + 0.1 : data['temp'])
          : 0.0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
      dust: data['dust'] != null
          ? (data['dust'] % 1 == 0 ? data['dust'] + 0.1 : data['dust'])
          : 0.0,
      humi: data['humi'] ?? 0,
      mq135: data['mq135'] ?? 0,
      mq4: data['mq4'] ?? 0,
      mq7: data['mq7'] ?? 0,
    );
  }
}

/// Device control model
class DeviceData {
  bool? r1;
  bool? isAuto;

  DeviceData({
     required this.r1,
     required this.isAuto
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      r1: data['r1'] ?? false,
      isAuto: data['isAuto']??false,
    );
  }

  Map<String, dynamic> toJson() => {
        'r1': r1,
        'isAuto':isAuto
      };
}
