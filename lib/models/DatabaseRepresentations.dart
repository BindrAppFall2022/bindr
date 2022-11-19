import '../controllers/DatabaseInteractionSkeleton.dart';
import "package:cloud_firestore/cloud_firestore.dart";

enum Condition { excellent, veryGood, good, acceptable, bad }

Map<Condition, String> conditionStrings = {
  Condition.excellent: "Excellent",
  Condition.veryGood: "Very good",
  Condition.good: "Good",
  Condition.acceptable: "Acceptable",
  Condition.bad: "Bad"
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
