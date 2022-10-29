import 'package:bindr_app/Book_information/getInfo.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bindr_app/Book_information/getInfo.dart';

class sell_screen extends StatelessWidget {
  String ISBN = "";

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
          rounded_input_field(
            // enter isbn
            hide: false,
            hintText: "ENTER ISBN",
            icon: Icons.book_sharp,
            onChanged: (value) {
              ISBN = value;
            },
          ),
          const rounded_input_field(
            // enter condition
            hide: false,
            hintText: "ENTER CONDITION",
            icon: Icons.api_sharp,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            onPressed: () {
              getInfo(ISBN);
            },
            child: const Text(
              "GET BOOK INFO",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
