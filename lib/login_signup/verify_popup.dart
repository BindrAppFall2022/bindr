import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/login_signup/login.dart';
import "package:flutter/material.dart";
import 'package:bindr_app/items/constants.dart';

class VerifyPopup extends StatelessWidget {
  final String text;
  const VerifyPopup({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Hero(
            tag: "verify-email-popup",
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.3,
              child: Material(
                color: gray,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(size.height / 20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      text,
                      style:
                          TextStyle(color: pink, fontWeight: FontWeight.bold),
                      textScaleFactor: 1.35,
                      textAlign: TextAlign.center,
                    ),
                    RoundButton(
                        text: "Go To Login",
                        press: () {
                          //pop to allow backwards swipe to take to Welcome instead of Signup
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()));
                        })
                  ]),
                ),
              ),
            )));
  }
}
