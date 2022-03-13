// To parse this JSON data, do
//
//     final moodSleep = moodSleepFromJson(jsonString);

import 'dart:convert';

List<MoodSleep> moodSleepFromJson(String str) => List<MoodSleep>.from(json.decode(str).map((x) => MoodSleep.fromJson(x)));

String moodSleepToJson(List<MoodSleep> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MoodSleep {
  MoodSleep({
    required this.id,
    required this.moodName,
  });

  int id;
  String moodName;

  factory MoodSleep.fromJson(Map<String, dynamic> json) => MoodSleep(
    id: json["id"],
    moodName: json["moodName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "moodName": moodName,
  };
}