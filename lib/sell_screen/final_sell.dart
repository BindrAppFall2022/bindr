import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:flutter/material.dart';

class Confirm extends StatelessWidget {
  String cond;
  String price;
  String post_title;
  Object? book_name;
  Object? author;
  Object? isbn;
  Object? pic;
  String? description;
  late ImageProvider backgroundImage;

  Confirm({
    required this.post_title,
    required this.book_name,
    required this.author,
    required this.pic,
    required this.isbn,
    required this.cond,
    required this.price,
    this.description,
  });

  @override
  late String a = (author as List)[0].toString();
  late String i = (isbn as List)[0].toString();
  late String p = "\$ $price";
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: logobackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.topCenter,
                child: const Text(
                  "CONFIRM BOOK INFO",
                  style: TextStyle(color: pink, fontSize: 35),
                )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              color: Colors.black,
              child: Image.network("$pic"),
            ),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  cond as String,
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  book_name as String,
                  style: const TextStyle(color: pink, fontSize: 25),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  i, //i
                  style: const TextStyle(color: pink, fontSize: 25),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  a,
                  style: const TextStyle(color: pink, fontSize: 25),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  p,
                  style: const TextStyle(color: pink, fontSize: 25),
                )),
            RoundButton(
              text: "Confirm Listing",
              press: () {}, // Drew will write the function for this
            ),
            RoundButton(
              text: "Cancel",
              press: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
