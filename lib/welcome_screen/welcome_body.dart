import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/login_signup/login.dart';
import 'package:bindr_app/login_signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';

// will be making the dy here so that we can be consistent throughout the app
class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("LET'S FIND THAT NEXT BOOK",
              style: TextStyle(fontWeight: FontWeight.bold, color: pink)),
          Image.asset(
            "assets/bindr_images/Bindr_logo_.png",
            height: size.height * 0.45,
          ),
          RoundButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              }),
          RoundButton(
            text: "SIGN UP",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SignUp(), // swap this with sign up when done
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
