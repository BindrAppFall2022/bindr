import 'package:bindr_app/Book_information/getInfo.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:bindr_app/sell_screen/condition.dart';
import 'package:bindr_app/sell_screen/final_sell.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';
import 'dart:collection';

class sell_screen extends StatelessWidget {
  String isbn = "";
  String? cond = "";
  String price = "";
  String currcond = "";
  HashMap<String, Object?> map = new HashMap<String, String>();

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
              isbn = value;
            },
          ),
          condition_drop(), //drop down button for condition of book
          rounded_input_field(
            hide: false,
            hintText: "ENTER PRICE",
            icon: Icons.api_sharp,
            onChanged: (value) {
              price = value.toString();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            onPressed: () {
              // map of things from api. keys => Name, ISBN, Author, Image.. they're all different types...
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => confirm(
                          ISBN: isbn,
                          cond: currcond,
                          price: price,
                        )),
              );
            },
            child: const Text(
              "LIST BOOK",
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
