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
    queries.forEach((key, value) {
      String valueR = value.split('').reversed.join('');
      currentR = current
          .orderBy(key)
          .where(key, isGreaterThanOrEqualTo: valueR)
          .where(key, isLessThanOrEqualTo: "$valueR~");
      current = current
          .orderBy(key)
          .where(key, isGreaterThanOrEqualTo: value)
          .where(key, isLessThanOrEqualTo: "$value~");
    });
    QuerySnapshot resultSnapshot;
    List<T> result = [];
    for (Query? query in [current, currentR]) {
      if (query is Query) {
        Query<Object?>? q1;
        if (startPoint[0] != null) {
          q1 = query;
          //.limit(pageLimit)
          // .orderBy(orderBy, descending: descending)
          //.startAfter(startPoint);
        } else {
          q1 = query;
          //.limit(pageLimit)
          // .orderBy(orderBy, descending: descending);
        }
        await q1.get().then((value) {
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
          //debugPrint("Successful query!");
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
        FirebaseFirestore.instance.collection(getCollection());

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

  Future<int> newPostID() async {
    Query query = FirebaseFirestore.instance
        .collection(getCollection())
        .orderBy('date_created', descending: true)
        .limit(1);
    var value = await query.get().then(
      (value) {
        var resultSnapshot = value;
        if (resultSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> data =
              resultSnapshot.docs[0].data() as Map<String, dynamic>;
          return data["postid"] + 1;
        } else {
          return 1;
        }
      },
    ).catchError((error) {
      debugPrint("Failed operation with error: $error.");
      return 0;
    });
    return value;
  }

  Future<List<Post>> searchDB(String query, int pageLimit,
      {required String orderBy,
      required bool descending,
      required List<Object?> startPoint}) async {
    Set<Post> result = <Post>{};
    /////add book_name as a field
    for (String property in ["q_author", "q_title", "isbn", "q_book_name"]) {
      List<Post> curList = await getEntries({property: query}, pageLimit,
          orderBy: orderBy, descending: descending, startPoint: startPoint);
      result.addAll(curList);
    }
    List<Post> resultList = result.toList();
    if (result.length <= pageLimit) {
      return resultList;
    } else {
      return resultList.sublist(0, pageLimit);
    }
  }

  @override
  Post? createFrom(Map<String, dynamic> map) {
    List<String> allKeys = [
      "author",
      "book_name",
      "condition",
      "date_created",
      "description",
      "image_url",
      "isbn",
      "last_modified",
      "num_bookmarks",
      "postid",
      "price",
      "q_author",
      "q_book_name",
      "q_title",
      "title",
      "userid"
    ];
    for (String item in allKeys) {
      if (!map.containsKey(item)) {
        throw Exception(
            "The key $item was not found in the entry retrieved by the database.");
      }
    }

    if (!conditionToValue.containsValue(map["condition"])) {
      throw Exception(
          "The condition ${map["condition"]} as retrieved from the database is invalid.");
    }

    Condition cond = Condition.BAD;
    conditionToValue.forEach((key, value) {
      if (value == map["condition"]) cond = key;
    });

    return Post(
      author: map["author"],
      bookName: map["book_name"],
      condition: cond,
      dateCreated: map["date_created"],
      description: map["description"],
      imageURL: map["image_url"],
      lastModified: map["last_modified"],
      numBookmarks: map["num_bookmarks"],
      isbn: map["isbn"],
      postID: map["postid"],
      price: map["price"],
      qAuthor: map["q_author"],
      qBookName: map["q_book_name"],
      qTitle: map["q_title"],
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
        FirebaseFirestore.instance.collection(getCollection());
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
        FirebaseFirestore.instance.collection(getCollection());

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
