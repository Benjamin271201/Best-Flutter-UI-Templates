import 'dart:convert';

Mood moodFromJson(String str) => Mood.fromJson(json.decode(str));

String moodToJson(Mood data) => json.encode(data.toJson());

class Mood {
  Mood({
    required this.id,
    required this.name,
    required this.count
  });

  int id;
  String name;
  int count;

  factory Mood.fromJson(Map<String, dynamic> json) => Mood (
    id: json["id"],
    name: json["name"],
    count: json["count"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "count": count
  };
}