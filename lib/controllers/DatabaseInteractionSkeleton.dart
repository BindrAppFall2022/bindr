import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/DatabaseRepresentations.dart';
import "package:cloud_firestore/cloud_firestore.dart";

// Use descendants of this class to retrieve data from the database
abstract class DBSerialize<T extends DBRepresentation<T>> {
  String getCollection();
  T? createFrom(Map<String, dynamic> map, String docId);

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

            T? item =
                createFrom(element.data() as Map<String, dynamic>, element.id);
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

    T? result =
        createFrom(queryRes.data() as Map<String, dynamic>, queryRes.id);
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

  Future<bool> isBookmarked({required int postid}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Query query =
        FirebaseFirestore.instance.collection(UserSerialize().getCollection());
    bool result = await query
        .where(FieldPath.documentId, isEqualTo: uid)
        .where("bookmarks", arrayContains: postid)
        .count()
        .get()
        .then((value) => value.count > 0)
        .catchError((error) {
      debugPrint("Failed operation with error: $error.");
    });
    return result;
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
  Post? createFrom(Map<String, dynamic> map, String docId) {
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
      documentID: docId,
    );
  }
}

class UserSerialize extends DBSerialize<BindrUser> {
  @override
  String getCollection() {
    return "users";
  }

  Future<bool> addBookmark({required int postid, required String docID}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    bool result = true;
    await FirebaseFirestore.instance
        .collection(getCollection())
        .doc(uid)
        .update({
      "bookmarks": FieldValue.arrayUnion([postid])
    }).catchError((error) {
      result = false;
      debugPrint("Failed operation with error: $error.");
    });
    if (result) {
      await FirebaseFirestore.instance
          .collection(PostSerialize().getCollection())
          .doc(docID)
          .update({"num_bookmarks": FieldValue.increment(1)}).catchError(
              (error) {
        result = false;
        debugPrint("Failed operation with error: $error.");
      });
    }
    return result;
  }

  Future<bool> removeBookmark(
      {required int postid, required String docID}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    bool result = true;
    await FirebaseFirestore.instance
        .collection(getCollection())
        .doc(uid)
        .update({
      "bookmarks": FieldValue.arrayRemove([postid])
    }).catchError((error) {
      result = false;
      debugPrint("Failed operation with error: $error.");
    });
    if (result) {
      await FirebaseFirestore.instance
          .collection(PostSerialize().getCollection())
          .doc(docID)
          .update({"num_bookmarks": FieldValue.increment(-1)}).catchError(
              (error) {
        result = false;
        debugPrint("Failed operation with error: $error.");
      });
    }

    return result;
  }

  //For each postID, delete other user's bookmarks of that post
  removeBookmarksOfPostIDList(List<int> postIDs) async {
    if (postIDs.isEmpty) {
      return false;
    }

    bool hadError = false;

    Query bookmarksQuery =
        FirebaseFirestore.instance.collection(getCollection());

    final batch = FirebaseFirestore.instance.batch();

    await bookmarksQuery
        .where("bookmarks", arrayContainsAny: postIDs)
        .get()
        .then((snapshot) {
      for (var element in snapshot.docs) {
        var ref = element.reference;
        batch.update(ref, {"bookmarks": FieldValue.arrayRemove(postIDs)});
        // List<int> bookmarksList = element.get("Bookmarks") as List<int>;
        // bookmarksList.removeWhere((item) => postIDs.contains(item));
      }
    }).catchError((error) {
      debugPrint("Failed operation with error: $error.");
      hadError = true;
    });

    if (hadError) {
      return false;
    }

    //commit the updates
    batch.commit().then((value) => {}).catchError((error) {
      debugPrint("Failed operation with error: $error.");
      hadError = true;
    });

    return !hadError;
  }

  // returns true on success and false on failure
  Future<bool> deleteUser() async {
    bool hadError = false;
    String userid = FirebaseAuth.instance.currentUser!.uid;
    //Delete Posts made by user and track all postIDs to remove
    List<int> postIDs = <int>[];
    Query postQuery =
        FirebaseFirestore.instance.collection(PostSerialize().getCollection());
    await postQuery.where("userid", isEqualTo: userid).get().then(
      (snapshot) async {
        for (QueryDocumentSnapshot<Object?> element in snapshot.docs) {
          if (!element.exists) {
            continue;
          }
          postIDs.add(element.get("postid") as int);
          await element.reference.delete();
        }
      },
    ).catchError((error) {
      debugPrint("Failed operation with error: $error.");
      hadError = true;
    });

    if (hadError) {
      return false;
    }

    hadError = await UserSerialize().removeBookmarksOfPostIDList(postIDs);

    if (hadError) {
      return false;
    }

    //Delete user entry and auth entry

    CollectionReference coll =
        FirebaseFirestore.instance.collection(getCollection());

    await coll.doc(userid).delete().then((value) {
      debugPrint("User Deleted");
    }).catchError((error) {
      debugPrint("Failed operation with error: $error.");
      hadError = true;
    });

    await FirebaseAuth.instance.currentUser!.delete();

    return !hadError;
  }

  Future<String?> getEmailFromHofID(String hofID) async {
    Query query = FirebaseFirestore.instance.collection(getCollection());

    query = query.where("hofid", isEqualTo: hofID);

    String? email;

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
  BindrUser? createFrom(Map<String, dynamic> map, String docId) {
    List<String> allKeys = [
      'bookmarks',
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
      lastAccessed: map["last_access"],
      userID: map["userid"],
    );
  }
}

// Use descendants of this class to write data to the database.
abstract class DBRepresentation<T> {
  // Becomes populated when the entry is written to the database.
  String? documentID;
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
    documentID = docReference;
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
