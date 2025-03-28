import 'package:faun_alert/pages/signin.dart';
import 'package:faun_alert/pages/signup.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool showSignIn = true;

  void toggleScreens() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
      if(showSignIn) {
        return Signin(goToSignup: toggleScreens);
      } else {
        return Signup(gotToSignin: toggleScreens);
      }
  }
}