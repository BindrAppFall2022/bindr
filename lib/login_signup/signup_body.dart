import 'dart:developer';

import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/login_signup/login.dart';
import 'package:bindr_app/login_signup/verify_popup.dart';
import 'package:bindr_app/models/DatabaseRepresentations.dart';
import 'package:bindr_app/services/auth.dart';
import 'package:bindr_app/services/validate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/items/rounded_input_field.dart';

import '../items/hero_dialogue_route.dart';

class SignUpBody extends StatefulWidget {
  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController _textEditingControllerU = TextEditingController();
  final TextEditingController _textEditingControllerE = TextEditingController();
  final TextEditingController _textEditingControllerEM =
      TextEditingController();
  final TextEditingController _textEditingControllerP = TextEditingController();
  final TextEditingController _textEditingControllerPM =
      TextEditingController();

  String? errorTextU, errorTextP, errorTextPM, errorTextE, errorTextEM;

  bool isLoading = false;

  String emailString = "";

  String confirmEmailString = "";

  String passwordString = "";

  String confirmPasswordString = "";

  String hofID = "";

  bool hofIDValidated = false;

  bool emailValidated = false;

  bool passwordValidated = false;

  bool emailsMatch = false;

  bool passwordsMatch = false;

  final Validate val = Validate();

  final auth = AuthService();

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerU.dispose();
    _textEditingControllerE.dispose();
    _textEditingControllerEM.dispose();
    _textEditingControllerP.dispose();
    _textEditingControllerPM.dispose();
  }

  register(context) async {
    setState(() {
      isLoading = true;
    });
    hofID = hofID.toLowerCase();
    emailString = emailString.toLowerCase();
    confirmEmailString = confirmEmailString.toLowerCase();
    if (confirmEmailString == emailString) {
      emailsMatch = true;
    } else {
      emailsMatch = false;
    }
    var resultList = await val.validateHofID(hofID);
    hofIDValidated = resultList[0];
    errorTextU = resultList[1];
    //add some else cases for each of these
    if (hofIDValidated &&
        emailValidated &&
        passwordValidated &&
        emailsMatch &&
        passwordsMatch) {
      //////Firebase will check if email exists.
      var result = await auth.registerUser(emailString, passwordString, hofID);
      if (result is String) {
        if (result == 'weak-password') {
          errorTextP = 'Error: The password provided is too weak';
        } else if (result == 'email-already-in-use') {
          errorTextE = 'Error: The account already exists for that email';
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
        String userID = result.user.uid;
        Timestamp currentTime = Timestamp.now();
        BindrUser newUser = BindrUser(
          bookmarks: [],
          dateCreated: currentTime,
          email: emailString,
          hofID: hofID,
          lastAccessed: currentTime,
          userID: userID,
        );
        //create database entry for user
        await newUser.createEntry();
        //send email verification
        await auth.signIn(emailString, passwordString);
        await auth.sendVerificationEmail();
        await auth.signOut();
      }
    } else {
      //check the rest of the cases here
      if (!emailValidated) {
        errorTextE =
            "Error: Email is not valid, please enter a valid Hofstra email";
      }
      if (!emailsMatch) {
        errorTextEM = "Error: Email must match the email you entered";
      }
      if (!passwordsMatch) {
        errorTextPM = "Error: Password must match the password you entered";
      }
    }
    setState(() {
      isLoading = false;
      _textEditingControllerE.text = emailString;
      _textEditingControllerEM.text = confirmEmailString;
      _textEditingControllerP.text = passwordString;
      _textEditingControllerPM.text = confirmPasswordString;
      _textEditingControllerU.text = hofID;
      errorTextU = errorTextU;
      errorTextP = errorTextP;
      errorTextPM = errorTextPM;
      errorTextE = errorTextE;
      errorTextEM = errorTextEM;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(elevation: 0, backgroundColor: logobackground),
            body: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("", // we can change this to whatever
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: pink)),
                  Image.asset(
                    "assets/bindr_images/Bindr_logo_.png",
                    height: size.height * 0.28,
                  ),
                  rounded_input_field(
                    controller: _textEditingControllerU,
                    errorText: errorTextU,
                    hide: false,
                    hintText: "Enter Hofstra ID",
                    onChanged: (value) async {
                      hofID = value;
                      setState(() {
                        errorTextU = null;
                      });
                    },
                    onSubmitted: (f) => register(context),
                    icon: Icons.account_circle_sharp,
                  ),
                  rounded_input_field(
                    controller: _textEditingControllerP,
                    errorText: errorTextP,
                    hide: true,
                    hintText: "Create Password",
                    onChanged: (value) {
                      setState(() {
                        errorTextP = null;
                      });
                      passwordString = value;
                      passwordValidated = val.validatePassword(passwordString);
                    },
                    onSubmitted: (f) => register(context),
                    icon: Icons.lock_sharp,
                  ),
                  rounded_input_field(
                    controller: _textEditingControllerPM,
                    errorText: errorTextPM,
                    hide: true,
                    hintText: "Confirm Password",
                    onChanged: (value) {
                      setState(() {
                        errorTextPM = null;
                      });
                      confirmPasswordString = value;
                      if (confirmPasswordString == passwordString) {
                        passwordsMatch = true;
                      } else {
                        //Outline confirm password box in red color,
                        //Red Text "Password must match the password you entered"
                        passwordsMatch = false;
                      }
                    },
                    onSubmitted: (f) => register(context),
                    icon: Icons.lock_sharp,
                  ),
                  rounded_input_field(
                    controller: _textEditingControllerE,
                    errorText: errorTextE,
                    hide: false,
                    hintText: "Enter Hofstra Email",
                    onChanged: (value) {
                      setState(() {
                        errorTextE = null;
                      });
                      emailString = value.toLowerCase();
                      if (!val.validateEmailField(emailString)) {
                        emailValidated = false;
                      } else {
                        emailValidated = true;
                      }
                    },
                    onSubmitted: (f) => register(context),
                    icon: Icons.account_circle_sharp,
                  ),
                  rounded_input_field(
                    controller: _textEditingControllerEM,
                    errorText: errorTextEM,
                    hide: false,
                    hintText: "Confirm Hofstra Email",
                    onChanged: (value) {
                      setState(() {
                        errorTextEM = null;
                      });
                      confirmEmailString = value;
                    },
                    onSubmitted: (f) => register(context),
                    icon: Icons.account_circle_sharp,
                  ),
                  RoundButton(
                    text: "SIGN UP",
                    press: () => register(context),
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
                              builder: (context) => Login(),
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
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(50),
                  )
                ],
              ),
            ),
          );
  }
}
