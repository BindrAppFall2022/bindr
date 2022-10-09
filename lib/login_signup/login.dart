import 'package:flutter/material.dart';
import 'package:bindr_app/login_signup/login_body.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: login_body(),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
