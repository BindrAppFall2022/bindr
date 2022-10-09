import 'package:flutter/material.dart';
import 'package:bindr_app/login_signup/signup_body.dart';

class Sign_Up extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: signup_body(),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
