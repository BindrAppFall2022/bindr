import 'package:bindr_app/services/get_info.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/items/rounded_input_field.dart';
import 'package:bindr_app/search_screen/search_screen.dart';
import 'package:bindr_app/sell_screen/final_sell.dart';
import 'package:bindr_app/services/validate.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';

class SellScreen extends StatefulWidget {
  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  String? post_title;

  String? isbn;

  String? description;

  String? price;

  String? _dropdownValue;

  Validate validator = Validate();

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

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
            // enter post title
            maxLength: 50,
            hide: false,
            hintText: "ENTER TITLE OF LISTING",
            icon: Icons.title_sharp,
            onChanged: (value) {
              post_title = value;
            },
          ),
          rounded_input_field(
            maxLength: 13,
            hide: false,
            hintText: "ENTER ISBN",
            icon: Icons.book_sharp,
            onChanged: (value) {
              isbn = value;
            },
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                color: gray,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: gray,
                  ),
                  child: DropdownButton<String>(
                    value: _dropdownValue,
                    isExpanded: true,
                    hint: const Text("SELECT CONDITION",
                        style: TextStyle(color: logobackground)),
                    items: const [
                      DropdownMenuItem(
                        value: "NEW",
                        child: Text("NEW",
                            style: TextStyle(color: logobackground)),
                      ),
                      DropdownMenuItem(
                        value: "GREAT",
                        child: Text("GREAT",
                            style: TextStyle(color: logobackground)),
                      ),
                      DropdownMenuItem(
                        value: "GOOD",
                        child: Text("GOOD",
                            style: TextStyle(color: logobackground)),
                      ),
                      DropdownMenuItem(
                        value: "BAD",
                        child: Text("BAD",
                            style: TextStyle(color: logobackground)),
                      ),
                      DropdownMenuItem(
                        value: "POOR",
                        child: Text("POOR",
                            style: TextStyle(color: logobackground)),
                      ),
                    ],
                    onChanged: dropdownCallback,
                  ))), //drop down button for condition of book
          rounded_input_field(
              maxLength: 200,
              hide: false,
              hintText: "ADDITIONAL DETAILS (optional)",
              icon: Icons.format_align_left_sharp,
              onChanged: (value) {
                description = value;
              }),
          rounded_input_field(
            maxLength: 10,
            hide: false,
            hintText: "ENTER PRICE",
            icon: Icons.attach_money,
            onChanged: (value) {
              price = value;
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            onPressed: () async {
              //now validate fields
              if (validator.validateISBN(isbn) &&
                  validator.validatePrice(price) &&
                  validator.validateTitle(post_title) &&
                  _dropdownValue is String) {
                if (description is! String) {
                  description = "";
                }
                Map<String, Object?>? info = await getInfo(isbn!);
                if (info == null) {
                  ////ERROR: ISBN NOT FOUND, PLEASE ENTER CORRECTLY
                  debugPrint(
                      "Error: ISBN not found, please make sure you typed it in correctly.");
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Confirm(
                              post_title: post_title!,
                              isbn: info["ISBN"],
                              book_name: info["Name"],
                              author: info["Author"],
                              cond: _dropdownValue!,
                              description: description,
                              price: price!,
                              pic: info["Image"],
                            )),
                  );
                }
              } else {
                if (!validator.validateISBN(isbn)) {
                  debugPrint("Error: Please enter a valid ISBN-10 or ISBN-13");
                }
                if (!validator.validatePrice(price)) {
                  debugPrint("Error: Please enter a price in USD format");
                }
                if (!validator.validateTitle(post_title)) {
                  debugPrint("Error: Title must be at least 5 characters long");
                }
                if (_dropdownValue is! String) {
                  debugPrint(
                      "Error: Please select a value for the condition of the textbook");
                }
              }
            },
            child: const Text(
              "LIST BOOK",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: pink,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            child: const Text(
              "GO BACK",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
