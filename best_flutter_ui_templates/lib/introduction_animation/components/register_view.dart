import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../fitness_app/fitness_app_home_screen.dart';
import '../../service/HttpService.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

enum Gender { Male, Female }

class _RegisterViewState extends State<RegisterView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Gender? _gender = Gender.Male;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60.0, bottom: 8.0),
                  child: Text(
                    "Register",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: usernameController,
                    maxLength: 10,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    maxLength: 10,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Male'),
                      leading: Radio<Gender>(
                        value: Gender.Male,
                        groupValue: _gender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Female'),
                      leading: Radio<Gender>(
                        value: Gender.Female,
                        groupValue: _gender,
                        onChanged: (Gender? value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                  ],
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
                    color: Color(0xff132137),
                  ),
                  child: InkWell(
                    onTap: _signUpClick,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xff132137),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: _loginClick,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUpClick() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      if(usernameController.text.length < 4){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Username need to be at least 4 characters")));
        return;
      }
      if(passwordController.text.length < 4){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password need to be at least 4 characters")));
        return;
      }
      bool g;
      switch (_gender) {
        case Gender.Male:
          {
            g = true;
            break;
          }
        default:
          {
            g = false;
            break;
          }
      }
      var user = await HttpService()
          .register(usernameController.text, passwordController.text, g);
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FitnessAppHomeScreen(user: user)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Username or Password is incorrect")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill in all field")));
    }
  }

  void _loginClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }
}
