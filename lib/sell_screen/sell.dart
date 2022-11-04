import 'package:bindr_app/Book_information/getInfo.dart';
import 'package:bindr_app/login_signup/textfield/rounded_input_field.dart';
import 'package:bindr_app/sell_screen/final_sell.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';

class sell_screen extends StatefulWidget {
  @override
  State<sell_screen> createState() => _sell_screenState();
}

class _sell_screenState extends State<sell_screen> {
  String isbn = "";

  String? cond = "";

  String price = "";

  String? _dropdownValue;

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
            // enter isbn
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
                    hint: const Text("SELECT CONDITION",
                        style: TextStyle(color: logobackground)),
                    items: const [
                      DropdownMenuItem(
                        value: "NEW",
                        child: Text("NEW",
                            style: TextStyle(color: logobackground)),
                      ),
                      DropdownMenuItem(
                        value: "USED",
                        child: Text("USED",
                            style: TextStyle(color: logobackground)),
                      )
                    ],
                    onChanged: dropdownCallback,
                  ))), //drop down button for condition of book
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
            onPressed: () async {
              // map of things from api. keys => Name, ISBN, Author, Image.. they're all different types...
              Map<String, Object?> info = await getInfo(isbn);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => confirm(
                          ISBN: info["ISBN"],
                          Name: info["Name"],
                          author: info["Author"],
                          cond: _dropdownValue,
                          price: price,
                          pic: info["Image"],
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
