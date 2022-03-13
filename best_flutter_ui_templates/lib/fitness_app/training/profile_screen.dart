import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/welcome_view.dart';
import 'package:best_flutter_ui_templates/model/user.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required User user}) : this.user = user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User user;
  _ProfileScreenState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.username.toUpperCase(), style: TextStyle(color: Colors.green,fontSize: 26, fontWeight: FontWeight.bold),),backgroundColor: FitnessAppTheme.background,),
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
              fillColor: Colors.green,
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
