import 'package:flutter/material.dart';
import 'package:bindr_app/welcome.dart';
import 'package:bindr_app/login.dart';
import 'package:bindr_app/constants.dart';

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
      ),
      home: Welcome(),
    );
  }
}
