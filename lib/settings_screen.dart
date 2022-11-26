import 'package:bindr_app/items/constants.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class settings_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: logobackground,
      body: Center(
        child: Column(
          children: [
            RoundButton(
              text: "SIGN OUT",
              press: () {
                FirebaseAuth.instance.signOut; // sign out user
              },
            ),
            RoundButton(
              text: "DELETE ACCOUNT",
              press: () {}, // delete account here
            ),
            RoundButton(
                text: "RETURN",
                press: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    ));
  }
}
