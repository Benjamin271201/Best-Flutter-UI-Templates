import 'package:best_flutter_ui_templates/home/home_theme.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/welcome_view.dart';
import 'package:best_flutter_ui_templates/model/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "" ;
  @override
  void initState() {
    getUsername();
    super.initState();
  }

  getUsername() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username")!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(username.toUpperCase(), style: TextStyle(color: HomeTheme.nearlyDarkBlue,fontSize: 26, fontFamily: HomeTheme.fontName, fontWeight: FontWeight.bold),),backgroundColor: HomeTheme.background,),
      body:
      Center(
        child: profileCard(context),
      ),
    );
  }

  Widget profileCard(context) => Container(
    padding: const EdgeInsets.all(10),
    margin: EdgeInsets.only(top: 40, left: 16, right: 16),
    width: MediaQuery.of(context).size.width - 32,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          fillColor: HomeTheme.nearlyDarkBlue,
          splashColor: Colors.greenAccent,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.logout,
                  color: Colors.amber,
                  size: 32,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  "Logout",
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          shape: const StadiumBorder(),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeView()));
          },
        ),
      ],
    ),
  );
}