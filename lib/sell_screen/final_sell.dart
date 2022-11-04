import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:flutter/material.dart';

class confirm extends StatelessWidget {
  Object? cond;
  String price;
  Object? Name;
  Object? author;
  Object? ISBN;
  Object? pic;
  late ImageProvider backgroundImage;

  confirm({
    required this.Name,
    required this.author,
    required this.pic,
    required this.ISBN,
    required this.cond,
    required this.price,
  });

  @override
  late String a = (author as List)[0].toString();
  late String i = (ISBN as List)[0].toString();
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
                  Name as String,
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
