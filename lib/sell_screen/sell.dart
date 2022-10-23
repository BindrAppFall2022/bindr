import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:image_picker/image_picker.dart';

class sell_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: logobackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              alignment: Alignment.topCenter,
              child: const Text(
                "SELL YOUR BOOK",
                style: TextStyle(color: pink, fontSize: 35),
              )),
          const rounded_input_field(
            // enter isbn
            hide: false,
            hintText: "ENTER ISBN",
            icon: Icons.book_sharp,
          ),
          const rounded_input_field(
            // enter condition
            hide: false,
            hintText: "ENTER CONDITION",
            icon: Icons.api_sharp,
          ),
          const RoundButton(
            text: "LIST BOOK",
          )
        ],
      ),
    );
  }
}
