import 'package:flutter/material.dart';

import '../models/DatabaseRepresentations.dart';
import "package:cloud_firestore/cloud_firestore.dart";

// Use descendants of this class to retrieve data from the database
abstract class DBSerialize<T extends DBRepresentation<T>> {
  String getCollection();
  T? createFrom(Map<String, dynamic> map);

  Future<List<T>> getEntries(Map<String, String> queries, int pageLimit,
      {required String orderBy,
      required bool descending,
      required List<Object?> startPoint}) async {
    CollectionReference coll =
        FirebaseFirestore.instance.collection(getCollection());

    Query current = coll;
    Query? currentR;
    String lastKey = "";
    queries.forEach((key, value) {
      lastKey = key;
      String valueR = value.split('').reversed.join('');
      currentR = current
          .where(key, isGreaterThanOrEqualTo: valueR)
          .where(key, isLessThanOrEqualTo: "$valueR~");
      current = current
          .where(key, isGreaterThanOrEqualTo: value)
          .where(key, isLessThanOrEqualTo: "$value~");
    });
    current.get().then(((value) {}));
    QuerySnapshot resultSnapshot;
    List<T> result = [];
    for (Query? query in [current, currentR]) {
      if (query is Query) {
        await query
            .limit(pageLimit)
            //first orderBy has to be same as last key
            .orderBy(lastKey, descending: true)
            .orderBy(orderBy, descending: descending)
            //.startAt(startPoint)
            .get()
            .then((value) {
          resultSnapshot = value;
          for (var element in resultSnapshot.docs) {
            if (!element.exists) {
              continue;
            }

            T? item = createFrom(element.data() as Map<String, dynamic>);
            if (item != null) {
              result.add(item);
            }
          }
          debugPrint("Successful query!");
        }).catchError((error) {
          debugPrint("Failed operation with error: $error.");
        });
      }
    }
    return result;
  }

  // returns the object if found, null if not found
  Future<T?> readEntry(String doc) async {
    CollectionReference coll =
        await FirebaseFirestore.instance.collection(getCollection());

    var queryRes = await coll.doc(doc).get();

    T? result = createFrom(queryRes.data() as Map<String, dynamic>);
    return result;
  }
}

class PostSerialize extends DBSerialize<Post> {
  @override
  String getCollection() {
    return "posts";
  }

  Future<List<Post>> searchDB(String query, int pageLimit,
      {required String orderBy,
      required bool descending,
      required List<Object?> startPoint}) async {
    Set<Post> result = <Post>{};
    /////add book_name as a field
    for (String property in ["author", "title", "isbn"]) {
      List<Post> curList = await getEntries({property: query}, pageLimit,
          orderBy: orderBy, descending: descending, startPoint: startPoint);
      result.addAll(curList);
    }
    return result.toList();
  }

  @override
  Post? createFrom(Map<String, dynamic> map) {
    List<String> allKeys = [
      "author",
      "book_name",
      "condition",
      "date_added",
      "description",
      "image_url",
      "isbn",
      "last_modified",
      "num_bookmarks",
      "postid",
      "title",
      "userid"
    ];
    for (String item in allKeys) {
      if (!map.containsKey(item)) {
        throw Exception(
            "The key $item was not found in the entry retrieved by the database.");
      }
    }

    if (!conditionStrings.containsValue(map["condition"])) {
      throw Exception(
          "The condition ${map["condition"]} as retrieved from the database is invalid.");
    }

    Condition cond = Condition.BAD;
    conditionStrings.forEach((key, value) {
      if (value == map["condition"]) cond = key;
    });

    return Post(
      author: map["author"],
      bookName: map["book_name"],
      condition: cond,
      dateCreated: map["date_added"],
      description: map["description"],
      imageURL: map["image_url"],
      lastModified: map["last_modified"],
      numBookmarks: map["num_bookmarks"],
      isbn: map["isbn"],
      postID: map["postid"],
      title: map["title"],
      userID: map["userid"],
    );
  }
}

class UserSerialize extends DBSerialize<BindrUser> {
  @override
  String getCollection() {
    return "users";
  }

  @override
  BindrUser? createFrom(Map<String, dynamic> map) {
    List<String> allKeys = [
      "date_created",
      "email",
      "hofid",
      "last_access",
    ];

    for (String item in allKeys) {
      if (!map.containsKey(item)) {
        throw Exception(
            "The key $item was not found in the entry retrieved by the database.");
      }
    }

    return BindrUser(
      email: map["email"],
      hofID: map["hofid"],
      dateCreated: map["date_created"],
      lastAccessed: map["last-modified"],
      userID: map["userid"],
    );
  }
}

// Use descendants of this class to write data to the database.
abstract class DBRepresentation<T> {
  String getCollection();

  // returns the DocumentReference for firebase, or null if failed
  Future<String?> createEntry() async {
    bool hadError = false;
    String? docReference;
    await FirebaseFirestore.instance
        .collection(getCollection())
        .add(toMap())
        .then((value) {
      onSuccess(value);
      docReference = value.id;
    }).catchError((error) {
      onFailure(error);
    });

    return docReference;
  }

  // returns true on success and false on failure
  Future<bool> updateEntry(String doc) async {
    bool hadError = false;
    CollectionReference coll =
        await FirebaseFirestore.instance.collection(getCollection());
    coll.doc(doc).update(toMap()).then((value) {
      onSuccess("");
    }).catchError((err) {
      onFailure(err);
      hadError = true;
    });

    return !hadError;
  }

  // returns true on success and false on failure
  Future<bool> deleteEntry(String doc) async {
    bool hadError = false;
    CollectionReference coll =
        await FirebaseFirestore.instance.collection(getCollection());

    coll.doc(doc).delete().then((value) {
      onSuccess("");
    }).catchError((error) {
      onFailure(error);
      hadError = true;
    });

    return !hadError;
  }

  // returns list of entries from database

  Map<String, Object?> toMap();
  void onSuccess(value);
  void onFailure(err);
}
