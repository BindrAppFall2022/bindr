import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/login_signup/verify_popup.dart';
import 'package:bindr_app/search_screen/SearchScreen.dart';
import 'package:bindr_app/services/auth.dart';
import 'package:bindr_app/services/validate.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:bindr_app/login_signup/signup.dart';

import '../items/hero_dialogue_route.dart';

// will be making the dy here so that we can be consistent throughout the app
class LoginBody extends StatelessWidget {
  String usernameString = "";
  String emailString = "";
  String passwordString = "";
  bool signedIn = false;
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
            hintText: "Enter Email/Hofstra ID",
            onChanged: (value) {
              usernameString = value.toLowerCase();
            },
            icon: Icons.account_circle_sharp,
          ),
          rounded_input_field(
            hide: true,
            hintText: "Enter Password",
            onChanged: (value) {
              passwordString = value;
            },
            icon: Icons.lock_sharp,
          ),
          RoundButton(
            text: "LOGIN",
            press: () async {
              //check if username is either email or hofID
              if (!val.validateEmailField(usernameString)) {
                //check if the field is a hofstraID in database
                //if so, get the email from that query
              } else {
                emailString = usernameString;
              }
              if (signedIn) {
                await auth.signOut();
              }
              String? error = await auth.signIn(emailString, passwordString);
              if (error == null) {
                // ignore: use_build_context_synchronously
                if (await auth.isVerified()) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                } else {
                  Navigator.of(context).push(HeroDialogueRoute(
                    true,
                    builder: (context) {
                      return VerifyPopup(
                          buttonText: "Resend Verification Email",
                          buttonFunc: () async {
                            Navigator.of(context).pop();
                            await auth.sendVerificationEmail();
                          },
                          descText:
                              "Please verify your account before logging in. Click below to resend the verification email. Make sure to check your spam folder for the email.");
                    },
                  ));
                  signedIn = true;
                  usernameString = usernameString;
                  passwordString = passwordString;
                }
              } else {
                print(error);
                return const Center(
                    child: Text('error', textDirection: TextDirection.ltr));
                //Red text on top of input fields with
                //text saying "The email and/or password you entered is incorrect,
                //please try again."
              }
              //return const Center(child: CircularProgressIndicator());
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
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
    ));
  }
}
