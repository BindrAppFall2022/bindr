import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:bindr_app/items/bindr_drawer.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                backgroundcolor: const Color.fromARGB(255, 215, 14, 0),
                text: "DELETE ACCOUNT",
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext innerContext) {
                      return Scaffold(
                        body: Center(
                          child: Container(
                            width: MediaQuery.of(innerContext).size.width * .9,
                            height:
                                MediaQuery.of(innerContext).size.height * .8,
                            color: logobackground,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Are you sure you want to delete your account?",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.red),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(innerContext)
                                              .size
                                              .width /
                                          3,
                                      child: RoundButton(
                                        text: "Yes",
                                        press: () async {
                                          //Delete post
                                          await UserSerialize().deleteUser();
                                          Navigator.of(context).popUntil(
                                              (route) => !Navigator.of(context)
                                                  .canPop());
                                        },
                                      ),
                                    ),
                                    Container(
                                      color: const Color.fromARGB(0, 0, 0, 0),
                                      width: MediaQuery.of(innerContext)
                                              .size
                                              .width /
                                          6,
                                    ),
                                    Container(
                                      width: MediaQuery.of(innerContext)
                                              .size
                                              .width /
                                          3,
                                      child: RoundButton(
                                        text: "No",
                                        press: () {
                                          Navigator.of(innerContext).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
                // () async {
                //   bool error = await UserSerialize().deleteUser();
                //   if (!error) {
                //     Navigator.of(context)
                //         .popUntil((route) => !Navigator.of(context).canPop());
                //   }
                // },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
