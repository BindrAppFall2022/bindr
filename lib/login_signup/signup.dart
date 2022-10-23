import 'package:flutter/material.dart';
import 'package:bindr_app/login_signup/signup_body.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignUpBody(),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
