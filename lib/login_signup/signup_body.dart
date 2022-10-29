import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/login_signup/login.dart';
import 'package:bindr_app/services/auth.dart';
import 'package:bindr_app/services/validate.dart';
import 'package:bindr_app/welcome_screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';

// will be making the dy here so that we can be consistent throughout the app
class SignUpBody extends StatelessWidget {
  String emailString = "";
  String passwordString = "";
  String hofID = "";
  bool hofIDValidated = false;
  bool emailValidated = false;
  bool passwordValidated = false;
  bool emailsMatch = false;
  bool passwordsMatch = false;
  final Validate val = Validate();
  final auth = AuthService();

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
            hintText: "Enter Hofstra ID",
            onChanged: (value) {
              hofID = value;
              if (val.validateHofID(hofID)) {
                hofIDValidated = true;
              } else {
                //Outline hofID box in red
                //Red Text "Please enter a valid Hofstra ID"
                hofIDValidated = false;
              }
            },
            icon: Icons.account_circle_sharp,
          ),
          rounded_input_field(
            hide: true,
            hintText: "Create Password",
            onChanged: (value) {
              passwordString = value;
              if (val.validatePassword(passwordString)) {
                passwordValidated = true;
              } else {
                //Outline Password Field in red and
                //Red Text Saying : :::::::::::;;;;
                passwordValidated = false;
              }
            },
            icon: Icons.lock_sharp,
          ),
          rounded_input_field(
            hide: true,
            hintText: "Confirm Password",
            onChanged: (value) {
              if (value == passwordString) {
                passwordsMatch = true;
              } else {
                //Outline confirm password box in red color,
                //Red Text "Password must match the password you entered"
                passwordsMatch = false;
              }
            },
            icon: Icons.lock_sharp,
          ),
          rounded_input_field(
            hide: false,
            hintText: "Enter Hofstra Email",
            onChanged: (value) {
              emailString = value;
              if (!val.validateEmailField(emailString)) {
                //Outline email box in red color,
                //Red Text "Please enter a valid Hofstra email"
                emailValidated = false;
              } else {
                emailValidated = true;
              }
            },
            icon: Icons.account_circle_sharp,
          ),
          rounded_input_field(
            hide: false,
            hintText: "Confirm Hofstra Email",
            onChanged: (value) {
              if (value == emailString) {
                emailsMatch = true;
              } else {
                //Outline confirm email box in red color,
                //Red Text "Email must match the email you entered"
                emailsMatch = false;
              }
            },
            icon: Icons.account_circle_sharp,
          ),
          RoundButton(
            text: "SIGN UP",
            press: () {
              if (hofIDValidated &&
                  emailValidated &&
                  passwordValidated &&
                  emailsMatch &&
                  passwordsMatch) {
                //check if username already exists.
                //Firebase will check if email exists.
                //Register User
                /*result = */ auth.registerUser(
                    emailString, passwordString, hofID);
                //check result to see if we should continue
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        Login(), //Should we sign the user automatically?
                  ),
                );
              }
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
                    Navigator.of(context).pushReplacement(
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
