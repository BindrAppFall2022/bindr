import 'package:bindr_app/items/rounded_button.dart';
import "package:flutter/material.dart";
import 'package:bindr_app/items/constants.dart';

class VerifyPopup extends StatelessWidget {
  final String descText;
  final String buttonText;
  final Function() buttonFunc;
  const VerifyPopup(
      {required this.descText,
      required this.buttonText,
      required this.buttonFunc,
      super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Wrap(children: [
      Hero(
          tag: "verify-email-popup",
          child: SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.3,
            child: Material(
              color: gray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.height / 28),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    descText,
                    style: const TextStyle(
                        color: pink, fontWeight: FontWeight.bold),
                    textScaleFactor: 1.35,
                    textAlign: TextAlign.center,
                  ),
                  RoundButton(text: buttonText, press: () => buttonFunc())
                ]),
              ),
            ),
          )),
    ]));
  }
}
