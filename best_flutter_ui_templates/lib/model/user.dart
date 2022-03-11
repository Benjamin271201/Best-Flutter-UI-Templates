// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.username,
    this.gender,
  });

  int? id;
  String? username;
  bool? gender;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "gender": gender,
  };
}