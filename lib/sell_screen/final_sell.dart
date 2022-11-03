import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:books_finder/books_finder.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/Book_information/getInfo.dart';

class confirm extends StatefulWidget {
  String ISBN;
  String cond;
  String price;

  confirm({
    required this.ISBN,
    required this.cond,
    required this.price,
  });

  @override
  State<confirm> createState() => _confirmState();
}

class _confirmState extends State<confirm> {
  Map<String, Object?> map = new Map<String, Object?>();

  @override
  Future<Widget?> build(BuildContext context) async {
    // no clue whats going on here
    final map = await getInfo(widget.ISBN);
    //final Uri img = map["Image"];
    final String Name = map[0];
    final String author = map[2];
    final String isbn = map[1];
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
            /*  Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  img,
                  height: 0.45,
                )), */
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  Name,
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.price,
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  isbn,
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  author,
                  style: const TextStyle(color: pink, fontSize: 35),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.cond,
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
