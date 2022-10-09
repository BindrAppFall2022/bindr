import 'package:bindr_app/items/constants.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/welcome_screen/welcome_body.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
