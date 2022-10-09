import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/login_signup/login.dart';
import 'package:bindr_app/welcome_screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';

// will be making the dy here so that we can be consistent throughout the app
class signup_body extends StatelessWidget {
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
            text: "SIGN UP",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Welcome(), // this should do the authentication
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Have an Account Already? ",
                style: TextStyle(color: gray),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Login(), // swap this with sign up when done
                      ),
                    );
                  },
                  child: const Text(
                    "LOG IN",
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
