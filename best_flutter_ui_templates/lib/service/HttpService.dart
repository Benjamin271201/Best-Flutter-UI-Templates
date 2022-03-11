import 'dart:convert';

import 'package:best_flutter_ui_templates/model/user.dart';
import 'package:http/http.dart' as http;

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
}