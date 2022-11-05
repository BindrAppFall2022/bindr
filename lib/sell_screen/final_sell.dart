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
  late String i2 = i.split(":")[1];
  late String p = "\$ $price";
  late String c = "CONDITION: $cond";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CONFIRM BOOK INFO",
          style: TextStyle(color: pink, fontSize: 25),
        ),
        backgroundColor: logobackground,
      ),
      backgroundColor: logobackground,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  post_title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: pink, fontSize: 40),
                )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              color: Colors.black,
              child: Image.network(
                "$pic",
                height: 400,
                width: 500,
                fit: BoxFit.contain,
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  c,
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  book_name as String,
                  style: const TextStyle(
                      color: pink, fontSize: 30, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  a, //i
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  i2,
                  style: const TextStyle(
                      color: pink, fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  description as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: pink, fontSize: 20),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  p,
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            RoundButton(
              text: "Confirm Listing",
              press: () {}, // Drew will write the function for this
            ),
          ],
        )),
      ),
    );
  }
}
