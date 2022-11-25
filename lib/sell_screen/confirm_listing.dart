import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/search_screen/search_screen.dart';
import 'package:flutter/material.dart';

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: logobackground,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              const Text(
                "BOOK LISTED",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 65,
                  color: pink,
                ),
              ),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        backgroundColor: logobackground,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                      },
                      child: const Text(
                        "PRESS TO CONTINUE",
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 20, color: pink),
                      )))
            ])));
  }
}