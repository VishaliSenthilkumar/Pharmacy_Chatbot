import 'package:flutter/material.dart';
import 'package:pharmacy_chatbot/screens/authenticate/register.dart';
import 'package:pharmacy_chatbot/screens/authenticate/sign_in.dart';


class Authenticate extends StatefulWidget {
  Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignIn = true;

  void toggleView() {
    setState(() {
      isSignIn = !isSignIn ;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isSignIn) return SignIn(toggleView: toggleView);
    else return Register(toggleView: toggleView);
  }
}
