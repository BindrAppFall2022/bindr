import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/models/DatabaseRepresentations.dart';
import 'package:bindr_app/search_screen/search_screen.dart';
import 'package:bindr_app/sell_screen/confirm_listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  late String authorStr, isbnListStr, isbnStr;

  @override
  Widget build(BuildContext context) {
    List authorList = (author as List);
    List isbnList = (isbn as List);
    if (authorList.isNotEmpty) {
      authorStr = authorList[0].toString();
    } else {
      authorStr = "None found";
    }
    if (isbnList.isNotEmpty) {
      isbnListStr = isbnList[0].toString();
      isbnStr = isbnListStr.split(":")[1];
    } else {
      isbnListStr = isbnStr = "None found";
    }
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
                  "Condition: $cond",
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
                  "Listing Price: $price",
                  style: const TextStyle(
                      color: pink, fontSize: 25, fontWeight: FontWeight.bold),
                )),
            RoundButton(
              text: "Confirm Listing",
              press: () async {
                int postID = await PostSerialize().newPostID();
                Post entry = Post(
                  author: authorStr,
                  bookName: book_name as String,
                  condition: con(cond),
                  dateCreated: Timestamp.fromDate(DateTime.now()),
                  description: description as String,
                  imageURL: "$pic",
                  isbn: isbnStr,
                  lastModified: Timestamp.fromDate(DateTime.now()),
                  numBookmarks: 0,
                  price: price,
                  postID: postID,
                  title: post_title,
                  userID: FirebaseAuth.instance.currentUser!.uid,
                );
                entry.createEntry().then((value) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ConfirmScreen()));
                });

                //.then((value) {
                //   Navigator.of(context)
                //     ..pop()
                //     ..pop()
                //     ..push(); //push the screen view
                // });
              },
            ),
          ],
        )),
      ),
    );
  }
}
