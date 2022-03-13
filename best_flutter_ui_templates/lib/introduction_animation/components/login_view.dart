import 'package:best_flutter_ui_templates/service/HttpService.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'register_view.dart';
import 'package:best_flutter_ui_templates/home/home_screen.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isInAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60.0, bottom: 8.0),
                  child: Text(
                    "Login",
                    style:
                    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      suffixIcon: Icon(Icons.abc),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: Icon(Icons.password),
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
                    color: Color(0xff132137),
                  ),
                  child: InkWell(
                    onTap: _loginClick,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Login",
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
                        "Don't have an account yet? ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color(0xff132137),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: _signUpClick,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  void _signUpClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterView()));
  }
  void _loginClick() async{
    FocusScope.of(context).requestFocus(new FocusNode());

    // start the modal progress HUD
    setState(() {
      _isInAsyncCall = true;
    });
    if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty){
      var user = await HttpService().login(usernameController.text, passwordController.text);
      if(user != null) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
      } else{
        setState(() {
          _isInAsyncCall = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Username or Password is incorrect")));
      }
    } else{
      setState(() {
        _isInAsyncCall = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill in all field")));
    }
  }
}
