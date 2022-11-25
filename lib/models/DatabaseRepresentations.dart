import 'package:flutter/material.dart';

import '../controllers/DatabaseInteractionSkeleton.dart';
import "package:cloud_firestore/cloud_firestore.dart";

enum Condition { NEW, GREAT, GOOD, BAD, POOR }

Map<Condition, String> conditionToString = {
  Condition.NEW: "NEW",
  Condition.GREAT: "GREAT",
  Condition.GOOD: "GOOD",
  Condition.BAD: "BAD",
  Condition.POOR: "POOR"
};

Map<Condition, int> conditionToValue = {
  Condition.NEW: 5,
  Condition.GREAT: 4,
  Condition.GOOD: 3,
  Condition.BAD: 2,
  Condition.POOR: 1
};

class Post extends DBRepresentation<Post> {
  String author;
  String bookName;
  Condition condition;
  Timestamp? dateCreated;
  String description;
  String imageURL;
  String isbn;
  Timestamp lastModified;
  int numBookmarks;
  int postID;
  String price;
  String qAuthor;
  String qBookName;
  String qTitle;
  String title;
  String userID;
  // Manage photos later

  Post(
      {required this.author,
      required this.bookName,
      required this.condition,
      required this.dateCreated,
      required this.description,
      required this.imageURL,
      required this.isbn,
      required this.lastModified,
      required this.numBookmarks,
      required this.postID,
      required this.price,
      required this.qAuthor,
      required this.qBookName,
      required this.qTitle,
      required this.title,
      required this.userID});

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> tomap = <String, Object?>{
      "author": author,
      "book_name": bookName,
      "condition": conditionToValue[condition],
      "date_created": dateCreated,
      "description": description,
      "image_url": imageURL,
      "isbn": isbn,
      "last_modified": lastModified,
      "num_bookmarks": numBookmarks,
      "postid": postID,
      "price": price,
      "q_author": author.toLowerCase(),
      "q_book_name": bookName.toLowerCase(),
      "q_title": title.toLowerCase(),
      "title": title,
      "userid": userID
    };
    //on update, don't change date_created
    if (dateCreated is! Timestamp) {
      tomap.remove("date_created");
    }
    return tomap;
  }

  Map<String, Comparable> toMapComparable() {
    Map<String, Comparable> tomap = <String, Comparable>{
      "condition": conditionToValue[condition]!,
      "last_modified": lastModified,
      "num_bookmarks": numBookmarks,
      "price": double.parse(price.substring(
        1,
      )),
      "q_book_name": bookName.toLowerCase(),
      "q_title": title.toLowerCase(),
    };
    return tomap;
  }

  @override
  String getCollection() {
    return "posts";
  }

  @override
  void onSuccess(value) {
    debugPrint("Successful operation on user with id: $userID.");
  }

  @override
  void onFailure(err) {
    debugPrint("Failed operation on user with id: $userID\nError: $err");
  }

  //For the set comparisons
  @override
  bool operator ==(Object other) {
    return postID == other.hashCode;
  }

  @override
  int get hashCode => postID;

  // @override
  // static Future<Post> readEntry(Map<String, String> queries) {
  //   bool hadError = false;
  //   CollectionReference posts = await FirebaseFirestore.instance.collection(getCollection());

  // }
}

class BindrUser extends DBRepresentation<BindrUser> {
  Timestamp? dateCreated;
  Timestamp lastAccessed;
  String userID;
  String email;
  String hofID;

  BindrUser({
    required this.email,
    required this.hofID,
    required this.userID,
    required this.lastAccessed,
    required this.dateCreated,
  });

  // returns the DocumentReference for firebase, or null if failed
  @override
  Future<String?> createEntry() async {
    String? docReference;
    await FirebaseFirestore.instance
        .collection(getCollection())
        .doc(userID)
        .set(
          toMap(),
        )
        .then(((value) {
      onSuccess("");
      docReference = userID;
    })).catchError((error) {
      onFailure(error);
    });

    return docReference;
  }

  @override
  Map<String, Object?> toMap({onUpdate = false}) {
    var tomap = <String, Object?>{
      "date_created": dateCreated,
      "email": email.toString(),
      "hofid": hofID,
      "last_access": lastAccessed,
    };
    //on update, don't change dateAdded
    if (dateCreated is! Timestamp) {
      tomap.remove("date_created");
    }
    return tomap;
  }

  @override
  String getCollection() {
    return "users";
  }

  @override
  void onSuccess(value) {
    debugPrint("Successful operation on user with id: $userID.");
  }

  @override
  void onFailure(err) {
    debugPrint("Failed operation on user with id: $userID\nError: $err");
  }
}
