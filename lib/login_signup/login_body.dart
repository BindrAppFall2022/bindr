import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/welcome_screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:bindr_app/login_signup/signup.dart';

// will be making the dy here so that we can be consistent throughout the app
class login_body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("", // we can change this to whatever
              style: TextStyle(fontWeight: FontWeight.bold, color: pink)),
          Image.asset(
            "assets/bindr_images/Bindr_logo_.png",
            height: size.height * 0.3,
          ),
          rounded_input_field(
            hide: false,
            hintText: "Enter Email",
            onChanged: (value) {},
            icon: Icons.account_circle_sharp,
          ),
          rounded_input_field(
            hide: true,
            hintText: "Enter Password",
            onChanged: (value) {},
            icon: Icons.lock_sharp,
          ),
          RoundButton(
            text: "LOGIN",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Welcome(), // this should send them to the main screen
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Don't Have an Account Yet? ",
                style: TextStyle(color: gray),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Sign_Up(), // swap this with sign up when done
                      ),
                    );
                  },
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: gray,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
