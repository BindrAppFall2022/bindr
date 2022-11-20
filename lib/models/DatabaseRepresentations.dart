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
  DateTime? dateAdded;
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
      required this.description,
      DateTime? dateAdded_,
      required this.imageURL,
      required this.lastModified,
      required this.numBookmarks,
      required this.title,
      required this.userID}) {
    // Must do this because DateTime.now() is not a constant, and so cannot be used above.
    dateAdded = dateAdded_ ?? DateTime.now();
  }

  @override
  Map<String, String> toMap() {
    return <String, String>{
      "author": author,
      "condition": conditionStrings[condition] ?? "",
      "date-added": dateAdded?.millisecondsSinceEpoch.toString() ?? "-1",
      "description": description,
      "image-url": imageURL,
      "last-modified": lastModified.millisecondsSinceEpoch.toString(),
      "num_bookmarks": numBookmarks.toString(),
      "isbn": isbn,
      "title": title,
      "userid": userID
    };
  }

  @override
  String getCollection() {
    return "posts";
  }

  @override
  void onSuccess(value) {
    print("Successful operation on user with id: $userID.");
  }

  @override
  void onFailure(err) {
    print("Failed operation on user with id: $userID\nError: $err");
  }

  // @override
  // static Future<Post> readEntry(Map<String, String> queries) {
  //   bool hadError = false;
  //   CollectionReference posts = await FirebaseFirestore.instance.collection(getCollection());

  // }
}

class BindrUser extends DBRepresentation<BindrUser> {
  DateTime? dateCreated;
  DateTime lastModified;
  String userID;
  String email;
  String hofID;

  BindrUser({
    required this.email,
    required this.hofID,
    required this.userID,
    required this.lastModified,
    DateTime? dateCreated,
  }) {
    // Must do this because DateTime.now() is not a constant, and so cannot be used above.
    dateCreated = dateCreated ?? DateTime.now();
  }

  // returns the DocumentReference for firebase, or null if failed
  @override
  Future<String?> createEntry() async {
    String? docReference;
    await FirebaseFirestore.instance
        .collection(getCollection())
        .doc(userID)
        .set(toMap())
        .then(((value) {
      onSuccess("");
      docReference = userID;
    })).catchError((error) {
      onFailure(error);
    });

    return docReference;
  }

  @override
  Map<String, String> toMap() {
    return <String, String>{
      "date_created": dateCreated?.millisecondsSinceEpoch.toString() ?? "-1",
      "email": email.toString(),
      "hofid": hofID,
      "last_access": lastModified.millisecondsSinceEpoch.toString(),
      //"userid": userID,
    };
  }

  @override
  String getCollection() {
    return "users";
  }

  @override
  void onSuccess(value) {
    print("Successful operation on user with id: $userID.");
  }

  @override
  void onFailure(err) {
    print("Failed operation on user with id: $userID\nError: $err");
  }
}
