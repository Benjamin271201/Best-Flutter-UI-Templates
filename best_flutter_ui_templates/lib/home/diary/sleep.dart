import 'dart:convert';

import 'package:best_flutter_ui_templates/home/stats/mood_chart_data.dart';

Sleep sleepFromJson(String str) => Sleep.fromJson(json.decode(str));

// String sleepToJson(Sleep data) => json.encode(data.toJson());

class Sleep {
  Sleep({
    required this.id,
    required this.slDescription,
    required this.sleepDate,
    required this.sleepDuration,
    required this.mood,
    required this.startSleep,
    required this.endSleep
  });

  int id;
  String slDescription;
  Data sleepDate;
  int sleepDuration;
  String mood;
  String startSleep;
  String endSleep;

  factory Sleep.fromJson(Map<String, dynamic> json) => Sleep (
      id: json["id"],
      slDescription: json["slDescription"],
      sleepDate: json["sleepDate"],
      sleepDuration: json["sleepDuration"],
      mood: json["mood"],
      startSleep: json["startSleep"],
      endSleep: json["endSleep"]
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "name": name,
  //   "count": count
  // };
}