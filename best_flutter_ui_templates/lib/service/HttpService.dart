
// ignore_for_file: unused_import

import 'dart:convert';

import 'package:best_flutter_ui_templates/home/stats/mood.dart';
import 'package:best_flutter_ui_templates/home/ui/add_sleep.dart';
import 'package:best_flutter_ui_templates/model/moodSleep.dart';
import 'package:best_flutter_ui_templates/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../home/diary/sleep.dart';

class HttpService {
  final String baseUrl = "https://sleeptracker.azurewebsites.net/api/";

  Future<User?> login(String username, String password) async{
    var client = http.Client();
    String body = json.encode({
      "username" : username,
      "password" : password
    });
    var res = await client.post(Uri.parse(baseUrl+"Users/login"),headers: {'Content-Type': 'application/json'},body: body);
    if(res.statusCode == 200){
      var json = res.body;
      return userFromJson(json);
    }
    else{
      return null;
    }
  }

  Future<User?> register(String username, String password, bool gender) async{
    var client = http.Client();
    String body = jsonEncode({
      "username" : username,
      "uPassword" : password,
      "gender" : gender
    });
    var res = await client.post(Uri.parse(baseUrl+"Users"),headers: {'Content-Type': 'application/json'},body: body);
    if(res.statusCode == 201){
      var json = res.body;
      return userFromJson(json);
    }
    else{
      return null;
    }
  }

  Future<List<Mood>> getMoodStatByMonth(int userId, int month, int year) async {
    var client = http.Client();
    final queryParameters = {
      'userId' : userId.toString(),
      "month" : month.toString(),
      "year" : year.toString()
    };
    final uri = Uri.https("sleeptracker.azurewebsites.net", '/api/Moods/summary', queryParameters);
    var res = await client.get(uri);
    if (res.statusCode == 200){
      var moodStatus = res.body;
      var moodStatusStr = json.decode(moodStatus).toString();
      moodStatusStr = moodStatusStr.substring(1, moodStatusStr.length-1);
      List<String> moodStatusStrList = moodStatusStr.split(", ").toList();
      List<Mood> moodStatusList = [];
      for (int i = 0; i<moodStatusStrList.length; i++) {
        Mood mood = new Mood(
            id: i,
            name: moodStatusStrList[i].split(":")[0],
            count: int.parse(moodStatusStrList[i].split(":")[1])
        );
        moodStatusList.add(mood);
      }
      print(moodStatusList);
      return moodStatusList;
    }
    else{
      throw new Exception("Error");
    }
  }

  Future<double> getAvgSleepByMonth(int userId, int month, int year) async {
    var client = http.Client();
    final queryParameters = {
      'userId' : userId.toString(),
      "month" : month.toString(),
      "year" : year.toString()
    };
    final uri = Uri.https("sleeptracker.azurewebsites.net", '/api/Sleeps/average', queryParameters);
    var res = await client.get(uri);
    if (res.statusCode == 200){
      var response = res.body;
      var result = response.substring(1, response.length-1).split(":")[1];
      return double.parse(result).ceilToDouble();
    }
    else{
      throw new Exception("Error");
    }
  }

  Future<double> getTotalSleepByMonth(int userId, int month, int year) async {
    var client = http.Client();
    final queryParameters = {
      'userId' : userId.toString(),
      "month" : month.toString(),
      "year" : year.toString()
    };
    final uri = Uri.https("sleeptracker.azurewebsites.net", '/api/Sleeps/total', queryParameters);
    var res = await client.get(uri);
    if (res.statusCode == 200){
      var response = res.body;
      var result = response.substring(1, response.length-1).split(":")[1];
      return double.parse(result).ceilToDouble();
    }
    else{
      throw new Exception("Error");
    }
  }

  Future<List<Sleep>> getSleepDiaryByMonth(int userId, int month, int year) async {
    var client = http.Client();
    final queryParameters = {
      'userId' : userId.toString(),
      'month' : month.toString(),
      'year' : year.toString()
    };
    final uri = Uri.https("sleeptracker.azurewebsites.net", '/api/Sleeps/user', queryParameters);
    var res = await http.get(uri);
    if (res.statusCode == 200){
       return sleepFromJson(res.body);
    }
    else{
      throw new Exception("Error");
    }
  }
  Future<List<MoodSleep>> getMoodList() async {
    var client = http.Client();
    final uri = Uri.parse(baseUrl + "Moods");
    var res = await http.get(uri);
    if (res.statusCode == 200){
      return moodSleepFromJson(res.body);
    }
    else{
      throw new Exception("Error");
    }
  }

  Future<bool> AddSleep(String startSleep, String endSleep, String sleepDate, String description, int userId, int moodId) async{
    var client = http.Client();
    String body = jsonEncode({
      "startHour": int.parse(startSleep.split(":")[0]),
      "startMinute": int.parse(startSleep.split(":")[1]),
      "endHour": int.parse(endSleep.split(":")[0]),
      "endMinute": int.parse(endSleep.split(":")[1]),
      "slDescription": description,
      "sleepDate": sleepDate,
      "moodId": moodId,
      "userId": userId
    });
    var res = await client.post(Uri.parse(baseUrl+"Sleeps"),headers: {'Content-Type': 'application/json'},body: body);
    if(res.statusCode == 201){
      var json = res.body;
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> removeSleep(int sleepId) async{
    var client = http.Client();
    var res = await client.delete(Uri.parse(baseUrl+"Sleeps/"+sleepId.toString()),headers: {'Content-Type': 'application/json'});
    if(res.statusCode == 204){
      return true;
    }
    else{
      return false;
    }
  }
  Future<String> getAdvice() async{
    var client = http.Client();
    final uri = Uri.parse(baseUrl + "Quotes/random");
    var res = await client.get(uri);
    if(res.statusCode == 200){
      String raw = json.decode(res.body).toString();
      raw = raw.substring(1,raw.length-1);
      return raw.split(": ")[1];
    }
    return "";
  }
}