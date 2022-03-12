import 'dart:convert';

import 'package:best_flutter_ui_templates/home/stats/mood.dart';
import 'package:best_flutter_ui_templates/model/user.dart';
import 'package:http/http.dart' as http;

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

  // Future<List<Mood>> getMoodStatByMonth(int month, int year) async {
  //   var client = http.Client();
  //   final body = {
  //     "month" : month,
  //     "year" : year
  //   };
  //   final uri = Uri.http(baseUrl, '/Sleeps', body);
  //   var res = await client.get(uri, headers: {'Content-Type': 'application/json'});
  //   if (res.statusCode == 201){
  //     var json = res.body;
  //     return moodFromJson(json);
  //   }
  //   else{
  //     throw new Exception("Error");
  //   }
  // }

  Future<List<Sleep>> getSleepDiaryByMonth(int userId, int month, int year) async {
    var client = http.Client();
    final body = {
      'id' : 6,
      'month' : month,
      'year' : year
    };
    final uri = Uri.http(baseUrl, '/Sleeps/user', body);
    var res = await http.get(uri);
    if (res.statusCode == 200){
       List<Sleep> list = (json.decode(res.body) as List)
           .map((data) => Sleep.fromJson(data))
           .toList();
       return list;
    }
    else{
      throw new Exception("Error");
    }
  }
}