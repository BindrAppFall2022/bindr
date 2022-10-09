import 'package:bindr_app/search_screen/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/welcome_screen/welcome.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/items/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bindr',
      theme: ThemeData(
        canvasColor: gray,
        splashColor: pink,
        primaryColor: logobackground,
      ),
      home: SearchScreen(),
    );
  }
}
