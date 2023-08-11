// To parse this JSON data, do
//
//     final devices = devicesFromJson(jsonString);

import 'dart:convert';

List<Devices> devicesFromJson(String str) =>
    List<Devices>.from(json.decode(str).map((x) => Devices.fromJson(x)));

String devicesToJson(List<Devices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Devices {
  String id;
  String deviceId;
  String deviceName;
  bool deviceType;
  List<double> location;
  DateTime updatedAt;
  String name;

  Devices({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.location,
    required this.updatedAt,
    required this.name,
  });

  factory Devices.fromJson(Map<String, dynamic> json) => Devices(
        id: json["id"],
        deviceId: json["deviceID"],
        deviceName: json["deviceName"],
        deviceType: json["deviceType"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceID": deviceId,
        "deviceName": deviceName,
        "deviceType": deviceType,
        "location": List<dynamic>.from(location.map((x) => x)),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
      };
}
