import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:bindr_app/items/rounded_button.dart';
import 'package:bindr_app/sell_screen/sell.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../items/constants.dart';
import '../models/DatabaseRepresentations.dart';

class PostView extends StatefulWidget {
  final Post activePost;

  const PostView(this.activePost, {super.key});

  @override
  State<PostView> createState() => _PostViewState(activePost);
}

class _PostViewState extends State<PostView> {
  Post activePost;
  String myId = FirebaseAuth.instance.currentUser!.uid;

  List<String> data = [];

  _PostViewState(this.activePost) {
    getData().then((value) => {setState(() => data = value)});
  }

  Future<List<String>> getData() async {
    BindrUser? otherUser = await UserSerialize().readEntry(activePost.userID);
    if (otherUser == null) {
      return ["Error"];
    }
    // These strings will be displayed directly on the post view screen.
    return [
      "Title: ${activePost.bookName}",
      "Author: ${activePost.author}",
      "ISBN: ${activePost.isbn}",
      activePost.description,
      "Price: ${activePost.price}",
      "Post created on: ${DateFormat("yMMMMEEEEd").format(activePost.dateCreated!.toDate())}",
      "Post created by ${myId == activePost.userID ? "you" : otherUser.email}",
      "Bookmark count: ${activePost.numBookmarks}",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
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
                            print("Edit post");
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
                                      color: gray,
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
                                                width:
                                                    MediaQuery.of(innerContext)
                                                            .size
                                                            .width /
                                                        3,
                                                child: RoundButton(
                                                  text: "Yes",
                                                  press: () {
                                                    //Delete post
                                                    activePost.deleteEntry(
                                                        activePost.documentID!);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              Container(
                                                color: const Color.fromARGB(
                                                    0, 0, 0, 0),
                                                width:
                                                    MediaQuery.of(innerContext)
                                                            .size
                                                            .width /
                                                        6,
                                              ),
                                              Container(
                                                width:
                                                    MediaQuery.of(innerContext)
                                                            .size
                                                            .width /
                                                        3,
                                                child: RoundButton(
                                                  text: "No",
                                                  press: () {
                                                    Navigator.of(innerContext)
                                                        .pop();
                                                    Navigator.of(context).pop();
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
                            print("Contact seller");
                            BindrUser? user = await UserSerialize()
                                .readEntry(activePost.userID);
                            if (user != null) {
                              String mailURL = "mailto:${user.email}";
                              try {
                                launchUrl(Uri.parse(mailURL));
                              } catch (e) {
                                print("Failed to launch mail url");
                              }
                            }
                          },
                        ),
                        RoundButton(
                          text: "Add/Remove Bookmark",
                          press: () {
                            print("Toggle bookmark");
                          },
                        ),
                      ],
                    )),
            ],
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
