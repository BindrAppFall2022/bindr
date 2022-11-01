import 'package:bindr_app/Book_information/getInfo.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:bindr_app/sell_screen/final_sell.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';

class sell_screen extends StatelessWidget {
  String isbn = "";
  String cond = "";
  String price = "";
  Map<String, Object>? info;

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
          rounded_input_field(
            // enter condition
            hide: false,
            hintText: "ENTER CONDITION",
            icon: Icons.api_sharp,
            onChanged: (value) {
              cond = value;
            },
          ),
          rounded_input_field(
            // enter condition
            hide: false,
            hintText: "ENTER PRICE",
            icon: Icons.api_sharp,
            onChanged: (value) {
              price = value;
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            onPressed: () {
              info = getInfo(
                  isbn); // map of things from api. keys => Name, ISBN, Author, Image.. they're all different types...
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => confirm(
                    name: getInfo(isbn)["Name"],
                    google_isbn: getInfo(isbn)["ISBN"],
                    author: getInfo(isbn)["Author"],
                    image: getInfo(isbn)["Image"],
                    cond: cond,
                    price: price,
                  ),
                ),
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
