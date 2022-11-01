import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';

class confirm extends StatelessWidget {
  String? name;
  String? cond;
  String? price;
  List<IndustryIdentifier>? google_isbn;
  List<String>? author;
  Uri? image;

  confirm({
    required this.name,
    required this.cond,
    required this.google_isbn,
    required this.author,
    required this.image,
    required this.price,
  });

  @override
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
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "$image",
                  height: 0.45,
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "$name",
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "$price",
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "$google_isbn",
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "$author",
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "$cond",
                  style: const TextStyle(color: pink, fontSize: 35),
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
