import 'package:bindr_app/items/bindr_drawer.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/rounded_button.dart';

import '../services/auth.dart';
import '../welcome_screen/welcome.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: logobackground,
        elevation: 0,
      ),
      backgroundColor: logobackground,
      drawer: BindrDrawer(currentPage: "SETTINGS"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundButton(
                text: "SIGN OUT",
                press: () async {
                  await auth.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Welcome()),
                      (route) => false);
                },
              ),
              RoundButton(
                backgroundcolor: Color.fromARGB(255, 215, 14, 0),
                text: "DELETE ACCOUNT",
                press: () {}, ///// delete account here
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
