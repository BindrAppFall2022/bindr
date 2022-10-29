import 'package:bindr_app/Book_information/getInfo.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bindr_app/Book_information/getInfo.dart';

class sell_screen extends StatelessWidget {
  String isbn = "";
  String cond = "";
  Map<String, Object>? info;
  String? name;
  List<IndustryIdentifier>? google_isbn;
  List<String>? author;
  Uri? image;

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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            onPressed: () {
              info = getInfo(
                  isbn); // map of things from api. keys => Name, ISBN, Author, Image.. they're all different types...
              name = getInfo(isbn)["Name"];
              google_isbn = getInfo(isbn)["ISBN"];
              author = getInfo(isbn)["Author"];
              image = getInfo(isbn)["Image"];
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
