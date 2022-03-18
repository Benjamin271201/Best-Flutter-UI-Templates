import 'package:best_flutter_ui_templates/home/home_theme.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/welcome_view.dart';
import 'package:best_flutter_ui_templates/model/user.dart';
import 'package:best_flutter_ui_templates/service/HttpService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "" ;
  TextEditingController oldPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  bool oldPassErr = false, confirmPassErr =false, newPassErr = false;

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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          fillColor: Colors.cyan,
          splashColor: Colors.greenAccent,
          child: Container(
            padding: EdgeInsets.all(10.0),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.error,
                  color: Colors.amber,
                  size: 32,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  "Change password",
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          shape: const StadiumBorder(),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Change Password'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: oldPass,
                          obscureText: true,
                          maxLength: 10,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Old Password',
                            suffixIcon: Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: confirmPass,
                          obscureText: true,
                          maxLength: 10,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirm Password',
                            suffixIcon: Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: newPass,
                          maxLength: 10,
                          obscureText: true,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'New Password',
                            suffixIcon: Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        padding: EdgeInsets.only(
                          left: 30.0,
                          right: 20.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xff2bb893),
                        ),
                        child: InkWell(
                          onTap: changePassword,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Confirm",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        padding: EdgeInsets.only(
                          left: 30.0,
                          right: 20.0,
                        ),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xff132137),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                        ),

                      ),
                    ],
                  ),
                ),

              );
            });
          },
        ),
        RawMaterialButton(
          fillColor: HomeTheme.nearlyDarkBlue,
          splashColor: Colors.greenAccent,
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 20),
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
  changePassword() async {
    if(oldPass.text.isNotEmpty && confirmPass.text.isNotEmpty && newPass.text.isNotEmpty){
      if(newPass.text.length < 4 || confirmPass.text.length < 4 || oldPass.text.length < 4){
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Warning!"),
              content: Text("Password need to be at least 4 characters"),
              actions: <Widget>[
                new TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      if(oldPass.text.compareTo(confirmPass.text) !=0){
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Warning!"),
              content: Text("Confirm password is not correct"),
              actions: <Widget>[
                new TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      bool res = await HttpService().changePass(oldPass.text, newPass.text);
      if(res){
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(""),
              content: Text("Change password success!"),
              actions: <Widget>[
                new TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                ),
              ],
            );
          },
        );
      } else{
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Warning!"),
              content: Text("Old password is not correct!"),
              actions: <Widget>[
                new TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();

                  },
                ),
              ],
            );
          },
        );
      }
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Warning!"),
            content: Text("Please fill in all fields!"),
            actions: <Widget>[
              new TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

  }
}
