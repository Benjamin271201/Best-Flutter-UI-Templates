import 'package:flutter/material.dart';

class MoodChartData{
  static List<Data> data = [
    Data("Happy", 10, Colors.blue),
    Data("Sad", 20, Colors.yellow),
    Data("Anxious", 30, Colors.red),
    Data("Sleepy", 40, Colors.green)
  ];
}

class Data {
  final String name;
  final int count;
  final Color color;

  Data(this.name, this.count, this.color);
}