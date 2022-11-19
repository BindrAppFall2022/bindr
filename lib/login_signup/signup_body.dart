import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/login_signup/login.dart';
import 'package:bindr_app/login_signup/verify_popup.dart';
import 'package:bindr_app/services/auth.dart';
import 'package:bindr_app/services/validate.dart';
import 'package:bindr_app/welcome_screen/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/items/rounded_input_field.dart';

import '../items/hero_dialogue_route.dart';

// will be making the dy here so that we can be consistent throughout the app
class SignUpBody extends StatelessWidget {
  String emailString = "";
  String confirmEmailString = "";
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
        child: SingleChildScrollView(
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
            onChanged: (value) async {
              hofID = value;
              //If ERROR Outline hofID box in red
              //Red Text "Please enter a valid Hofstra ID"
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
              emailString = value.toLowerCase();
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
              confirmEmailString = value;
            },
            icon: Icons.account_circle_sharp,
          ),
          RoundButton(
            text: "SIGN UP",
            press: () async {
              hofID = hofID.toLowerCase();
              emailString = emailString.toLowerCase();
              confirmEmailString = confirmEmailString.toLowerCase();
              if (confirmEmailString == emailString) {
                emailsMatch = true;
              } else {
                //Outline confirm email box in red color,
                //Red Text "Email must match the email you entered"
                emailsMatch = false;
              }
              hofIDValidated = await val.validateHofID(hofID);
              //add some else cases for each of these
              if (hofIDValidated &&
                  emailValidated &&
                  passwordValidated &&
                  emailsMatch &&
                  passwordsMatch) {
                /////check if username already exists.
                //////Firebase will check if email exists.
                var result =
                    await auth.registerUser(emailString, passwordString, hofID);
                if (result is String) {
                  if (result == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (result == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } else {
                  Navigator.of(context).push(HeroDialogueRoute(
                    false,
                    builder: (context) {
                      return VerifyPopup(
                          buttonText: "Go To Login",
                          buttonFunc: () {
                            //pop to allow backwards swipe to take to Welcome instead of Signup
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pushNamed('/welcome/login');
                          },
                          descText:
                              "Your account has been registered. We have sent a verification email to your account. Please verify your account before logging in.");
                    },
                  ));
                  //send email verification
                  print(emailString);
                  await auth.signIn(emailString, passwordString);
                  await auth.sendVerificationEmail();
                  await auth.signOut();
                }
              } else {
                //check cases here
                if (!hofIDValidated) {
                  print("ERROR: Hof ID is not valid");
                }
                if (!emailValidated) {
                  print("ERROR: Email is not valid");
                }
                if (!passwordValidated) {
                  print("ERROR: Password is not valid");
                }
                if (!emailsMatch) {
                  print("ERROR: Emails don't match");
                }
                if (!passwordsMatch) {
                  print("ERROR: Passwords do not match");
                }
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
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
