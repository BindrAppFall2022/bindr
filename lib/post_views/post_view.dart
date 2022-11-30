import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/my_bookmarks/my_bookmarks.dart';
import 'package:bindr_app/my_posts/my_posts.dart';
import 'package:bindr_app/sell_screen/sell.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../items/constants.dart';
import '../models/DatabaseRepresentations.dart';

class PostView extends StatefulWidget {
  final Post activePost;
  final String? searchString;
  final String? screen;

  const PostView(this.activePost, {this.searchString, this.screen, super.key});

  @override
  State<PostView> createState() => _PostViewState(activePost);
}

class _PostViewState extends State<PostView> {
  Post activePost;
  String myId = FirebaseAuth.instance.currentUser!.uid;
  bool isBookmarked = false;
  List<String> data = [];
  bool changed = false;

  _PostViewState(this.activePost) {
    getData().then((value) => {
          setState(() {
            data = value;
          })
        });
    bookmarked().then((value) {
      setState(() {
        isBookmarked = value;
      });
    });
  }

  Future<bool> bookmarked() async {
    return await PostSerialize().isBookmarked(postid: activePost.postID);
  }

  Future<List<String>> getData() async {
    BindrUser? otherUser = await UserSerialize().readEntry(activePost.userID);
    if (otherUser == null) {
      return ["Error"];
    }

    // These strings will be displayed directly on the post view screen.
    String price = activePost.price;
    activePost.price =
        activePost.price.replaceAll(',', '').replaceAll('\$', '');
    return [
      "Title: ${activePost.bookName}",
      "Author: ${activePost.author}",
      "ISBN: ${activePost.isbn}",
      (activePost.description != "")
          ? "Description: ${activePost.description}"
          : "",
      "Price: $price",
      "Textbook Condition: ${conditionToString[activePost.condition]}",
      "Post created on: ${DateFormat("yMMMMEEEEd").format(activePost.dateCreated!.toDate())}",
      "Post created by ${myId == activePost.userID ? "you" : otherUser.email}",

      "Bookmark count: ${activePost.numBookmarks}", //KEEP AT END OF LIST
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // total height and width of screen
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (widget.screen == 'bookmarks' && changed) {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacement(MaterialPageRoute(
                    builder: ((context) => MyBookmarks(
                        searchString: widget.searchString ?? "",
                        hasBookmarks: null)),
                  ));
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          backgroundColor: logobackground,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Image.network(
                  activePost.imageURL,
                  width: MediaQuery.of(context).size.width / 3,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: 2,
                  color: Theme.of(context).splashColor,
                ),
                Container(
                  height: 75,
                  color: Color.fromARGB(0, 0, 0, 0),
                ),
                ...data.map((e) => Text(
                      e,
                      style: const TextStyle(fontSize: 24, color: gray),
                      textAlign: TextAlign.center,
                    )),
                (myId == activePost.userID
                    ? Column(
                        children: [
                          RoundButton(
                            text: "Edit Post",
                            press: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SellScreen(currentPost: activePost),
                                ),
                              );
                            },
                          ),
                          RoundButton(
                            text: "Delete Post",
                            press: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext innerContext) {
                                  return Scaffold(
                                    body: Center(
                                      child: Container(
                                        width: MediaQuery.of(innerContext)
                                                .size
                                                .width *
                                            .9,
                                        height: MediaQuery.of(innerContext)
                                                .size
                                                .height *
                                            .8,
                                        color: logobackground,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Are you sure you want to delete this post?",
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(
                                                              innerContext)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: RoundButton(
                                                    text: "Yes",
                                                    press: () {
                                                      //Delete post
                                                      activePost.deleteEntry(
                                                          activePost
                                                              .documentID!);
                                                      Navigator.of(context)
                                                        ..pop()
                                                        ..pop()
                                                        ..pushReplacement(MaterialPageRoute(
                                                            builder: (context) =>
                                                                const MyPosts(
                                                                    searchString:
                                                                        "",
                                                                    hasPosts:
                                                                        null)));
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  color: const Color.fromARGB(
                                                      0, 0, 0, 0),
                                                  width: MediaQuery.of(
                                                              innerContext)
                                                          .size
                                                          .width /
                                                      6,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(
                                                              innerContext)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: RoundButton(
                                                    text: "No",
                                                    press: () {
                                                      Navigator.of(innerContext)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          RoundButton(
                            text: "Contact Seller",
                            press: () async {
                              BindrUser? user = await UserSerialize()
                                  .readEntry(activePost.userID);
                              if (user != null) {
                                String mailURL = "mailto:${user.email}";
                                try {
                                  launchUrl(Uri.parse(mailURL));
                                } catch (e) {
                                  debugPrint("Failed to launch mail url");
                                }
                              }
                            },
                          ),
                          (isBookmarked)
                              ? RoundButton(
                                  text: "Remove Bookmark",
                                  backgroundcolor:
                                      const Color.fromARGB(255, 215, 14, 0),
                                  press: (() async {
                                    await UserSerialize().removeBookmark(
                                        postid: activePost.postID,
                                        docID: activePost.documentID!);
                                    setState(() {
                                      changed = true;
                                      isBookmarked = false;
                                      activePost.numBookmarks -= 1;
                                      data[data.length - 1] =
                                          "Bookmark count: ${activePost.numBookmarks}";
                                    });
                                  }))
                              : RoundButton(
                                  text: "Add Bookmark",
                                  press: () async {
                                    await UserSerialize().addBookmark(
                                        postid: activePost.postID,
                                        docID: activePost.documentID!);
                                    setState(() {
                                      changed = true;
                                      isBookmarked = true;
                                      activePost.numBookmarks += 1;
                                      data[data.length - 1] =
                                          "Bookmark count: ${activePost.numBookmarks}";
                                    });
                                  },
                                ),
                        ],
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class PostView extends StatelessWidget {
//   late Post active_post;

//

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).primaryColor,
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               Image.network(
//                 active_post.imageURL,
//                 fit: BoxFit.fitWidth,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 2,
//                 color: Theme.of(context).splashColor,
//               ),
//             ],
//           ),
//         ));
//   }
// }
