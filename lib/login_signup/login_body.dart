import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/login_signup/verify_popup.dart';
import 'package:bindr_app/search_screen/search_screen.dart';
import 'package:bindr_app/services/auth.dart';
import 'package:bindr_app/services/validate.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/background.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/items/rounded_input_field.dart';
import 'package:bindr_app/login_signup/signup.dart';

import '../items/hero_dialogue_route.dart';

class LoginBody extends StatefulWidget {
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _textEditingControllerU = TextEditingController();
  final TextEditingController _textEditingControllerP = TextEditingController();

  String usernameString = "";

  String emailString = "";

  String passwordString = "";

  bool signedIn = false;

  final Validate val = Validate();

  final auth = AuthService();

  bool isLoading = false;

  login(context) async {
    setState(() {
      isLoading = true;
    });
    if (!val.validateEmailField(usernameString)) {
      emailString = await UserSerialize().getEmailFromHofID(usernameString) ??
          usernameString;
      if (emailString == "") {
        /////username not found
      }
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

      /////
    }
    setState(() {
      isLoading = false;
      _textEditingControllerU.text = usernameString;
      _textEditingControllerP.text = passwordString;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerU.dispose();
    _textEditingControllerP.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Background(
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
                  controller: _textEditingControllerU,
                  hide: false,
                  hintText: "Enter Email/Hofstra ID",
                  onChanged: (value) {
                    usernameString = value.toLowerCase();
                  },
                  onSubmitted: (p) => login(context),
                  icon: Icons.account_circle_sharp,
                ),
                rounded_input_field(
                  controller: _textEditingControllerP,
                  hide: true,
                  hintText: "Enter Password",
                  onChanged: (value) {
                    passwordString = value;
                  },
                  onSubmitted: (p) => login(context),
                  icon: Icons.lock_sharp,
                ),
                RoundButton(text: "LOGIN", press: () => login(context)),
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
