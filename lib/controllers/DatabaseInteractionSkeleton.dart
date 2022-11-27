import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/DatabaseRepresentations.dart';
import "package:cloud_firestore/cloud_firestore.dart";

// Use descendants of this class to retrieve data from the database
abstract class DBSerialize<T extends DBRepresentation<T>> {
  String getCollection();
  T? createFrom(Map<String, dynamic> map);

  Future<List<T>> getEntries(
    String key,
    String value,
    int? pageLimit, {
    String? orderBy,
    bool? descending,
    List<Object?>? startPoint,
    Query? q,
  }) async {
    Query current = (q is Query)
        ? q
        : FirebaseFirestore.instance.collection(getCollection());

    current = current
        .orderBy(key)
        .where(key, isGreaterThanOrEqualTo: value)
        .where(key, isLessThanOrEqualTo: "$value~");

    QuerySnapshot resultSnapshot;
    List<T> result = [];
    for (Query? query in [current]) {
      if (query is Query) {
        await query.get().then((value) {
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

  Future<List<Post>> getMyPosts({required String query}) async {
    Query postQuery = FirebaseFirestore.instance.collection(getCollection());
    String uid = FirebaseAuth.instance.currentUser!.uid;
    postQuery = postQuery.where("userid", isEqualTo: uid);
    return searchDB(query, null, q: postQuery);
  }

  Future<List<Post>> getMyBookmarks({required String query}) async {
    UserSerialize u = UserSerialize();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference document =
        FirebaseFirestore.instance.collection(u.getCollection()).doc(uid);
    DocumentSnapshot<Object?> docSnapshot = await document.get();
    List<int> bookmarkList = [0];
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      bookmarkList.addAll(List<int>.from(data["bookmarks"]));
    }
    Query postQuery = FirebaseFirestore.instance.collection(getCollection());
    postQuery = postQuery.where("postid", whereIn: bookmarkList);
    return searchDB(query, null, q: postQuery);
  }

  Future<List<Post>> searchDB(
    String query,
    int? pageLimit, {
    String? orderBy,
    bool? descending,
    List<Object?>? startPoint,
    Query? q,
  }) async {
    Set<Post> result = <Post>{};
    /////add book_name as a field
    for (String property in ["q_author", "q_title", "isbn", "q_book_name"]) {
      List<Post> curList = await getEntries(property, query, pageLimit,
          orderBy: orderBy,
          descending: descending,
          startPoint: startPoint,
          q: q);
      result.addAll(curList);
    }
    List<Post> resultList = result.toList();
    if (pageLimit == null || result.length <= pageLimit) {
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

  Future<String?> getEmailFromHofID(String hofID) async {
    Query query = FirebaseFirestore.instance.collection(getCollection());

    query = query.where("hofid", isEqualTo: hofID);

    String email = "";

    await query.get().then((snapshot) {
      for (var element in snapshot.docs) {
        if (!element.exists) {
          continue;
        }
        email = (element.data() as Map<String, dynamic>)["email"];
      }
    });
    return email;
  }

  @override
  BindrUser? createFrom(Map<String, dynamic> map) {
    List<String> allKeys = [
      'bookmarks'
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
      bookmarks: List<int>.from(map["bookmarks"]),
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
