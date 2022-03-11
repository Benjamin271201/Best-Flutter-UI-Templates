import 'package:best_flutter_ui_templates/introduction_animation/components/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_view.dart';
import 'register_view.dart';

class WelcomeView extends StatefulWidget {
  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                SizedBox(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 350, maxHeight: 350),
                    child: Image.asset(
                      'assets/introduction_animation/welcome.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    "Sleep Tracker",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 64, right: 64, top: 16, bottom: 16),
                  child: Text(
                    "The ultimate tool for tracking, storing, and maintaining a sleep plan",
                    textAlign: TextAlign.center,
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
                          Icon(Icons.arrow_forward_rounded, color: Colors.white)
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

  void _signUpClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterView()));
  }

  void _loginClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }
}
