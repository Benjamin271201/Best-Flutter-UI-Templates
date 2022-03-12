// To parse this JSON data, do
//
//     final sleep = sleepFromJson(jsonString);

import 'dart:convert';

List<Sleep> sleepFromJson(String str) => List<Sleep>.from(json.decode(str).map((x) => Sleep.fromJson(x)));

String sleepToJson(List<Sleep> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sleep {
  Sleep({
    required this.id,
    required this.slDescription,
    required this.sleepDate,
    required this.sleepDuration,
    required this.mood,
    required this.startSleep,
    required this.endSleep,
  });

  int id;
  String slDescription;
  DateTime sleepDate;
  int sleepDuration;
  String mood;
  String startSleep;
  String endSleep;

  factory Sleep.fromJson(Map<String, dynamic> json) => Sleep(
    id: json["id"],
    slDescription: json["slDescription"],
    sleepDate: DateTime.parse(json["sleepDate"]),
    sleepDuration: json["sleepDuration"],
    mood: json["mood"],
    startSleep: json["startSleep"],
    endSleep: json["endSleep"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slDescription": slDescription,
    "sleepDate": sleepDate.toIso8601String(),
    "sleepDuration": sleepDuration,
    "mood": mood,
    "startSleep": startSleep,
    "endSleep": endSleep,
  };
}
