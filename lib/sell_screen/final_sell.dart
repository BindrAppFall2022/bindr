import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/models/DatabaseRepresentations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

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

  Condition con(cond) {
    if (cond == 'NEW') {
      return Condition.NEW;
    } else if (cond == "GREAT") {
      return Condition.GREAT;
    } else if (cond == "GOOD") {
      return Condition.GOOD;
    } else if (cond == "BAD") {
      return Condition.BAD;
    } else {
      return Condition.POOR;
    }
  }

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

  late String authorStr = (author as List)[0].toString();
  late String isbnListStr = (isbn as List)[0].toString();
  late String isbnStr = isbnListStr.split(":")[1];
  late String priceStr = "\$ $price";
  late String condStr = cond;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "CONFIRM LISTING",
          style: TextStyle(color: pink, fontSize: 25),
        ),
        backgroundColor: logobackground,
      ),
      backgroundColor: logobackground,
      body: Center(
        heightFactor: 1.1,
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
              padding: const EdgeInsets.symmetric(vertical: 15),
              color: Colors.black,
              child: Image.network(
                "$pic",
                height: 350,
                width: 500,
                fit: BoxFit.contain,
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Condition: $condStr",
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "Textbook: $book_name",
                style: const TextStyle(
                    color: pink, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Author: $authorStr", //i
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "ISBN: $isbnStr",
                  style: const TextStyle(
                      color: pink, fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Description: $description",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: pink, fontSize: 20),
                )),
            Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Listing Price: $priceStr",
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            RoundButton(
              text: "Confirm Listing",
              press: () {
                /* Post(
                    author: author as String,
                    isbn: isbn as String,
                    condition: con(cond),
                    description: description as String,
                    imageURL: pic as String,
                    lastModified: DateTime.now(),
                    numBookmarks: 0,
                    title: book_name as String,
                    userID: ,
                    ); */
              }, ///// Drew will write the function for this
            ),
          ],
        )),
      ),
    );
  }
}
