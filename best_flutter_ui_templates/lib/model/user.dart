// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.token,
    required this.username,
    required this.gender,
  });

  String token;
  String username;
  bool gender;

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json["token"],
    username: json["username"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "username": username,
    "gender": gender,
  };
}