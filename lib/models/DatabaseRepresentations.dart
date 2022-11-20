import 'package:flutter/material.dart';

import '../controllers/DatabaseInteractionSkeleton.dart';
import "package:cloud_firestore/cloud_firestore.dart";

enum Condition { NEW, GREAT, GOOD, BAD, POOR }

Map<Condition, String> conditionStrings = {
  Condition.NEW: "NEW",
  Condition.GREAT: "GREAT",
  Condition.GOOD: "GOOD",
  Condition.BAD: "BAD",
  Condition.POOR: "POOR"
};

class Post extends DBRepresentation<Post> {
  String author;
  Condition condition;
  DateTime? dateCreated;
  String description;
  String imageURL;
  DateTime lastModified;
  String isbn;
  int numBookmarks;
  String title;
  String userID;
  // Manage photos later

  Post(
      {required this.author,
      required this.isbn,
      required this.condition,
      required this.dateCreated,
      required this.description,
      required this.imageURL,
      required this.lastModified,
      required this.numBookmarks,
      required this.title,
      required this.userID});

  @override
  Map<String, Object?> toMap() {
    Map<String, Object?> tomap = <String, Object?>{
      "author": author,
      "condition": conditionStrings[condition],
      "date_created": dateCreated,
      "description": description,
      "image_url": imageURL,
      "last_modified": lastModified,
      "num_bookmarks": numBookmarks,
      "isbn": isbn,
      "title": title,
      "userid": userID
    };
    //on update, don't change dateAdded
    if (dateCreated is! DateTime) {
      tomap.remove("date_added");
    }
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

  // @override
  // static Future<Post> readEntry(Map<String, String> queries) {
  //   bool hadError = false;
  //   CollectionReference posts = await FirebaseFirestore.instance.collection(getCollection());

  // }
}

class BindrUser extends DBRepresentation<BindrUser> {
  DateTime? dateCreated;
  DateTime lastAccessed;
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
    if (dateCreated is! DateTime) {
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
