// import 'dart:js';
import 'package:bindr_app/items/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bindr_app/sell_screen/sell.dart';

import '../services/auth.dart';
import '../welcome_screen/welcome.dart';

class SearchScreen extends StatelessWidget {
  //amount of the device screen height that the logo should be pushed down
  // default is .15
  final double logoYOffset;

  final double logoWidth;

  SearchScreen({super.key, this.logoYOffset = .15, this.logoWidth = .75});

  String currentSearchText = "";

  final auth = AuthService(); //Temporary

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: logobackground,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // dragStartBehavior: DragStartBehavior.down,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * logoYOffset,
            ),
            Container(
              width: MediaQuery.of(context).size.width * logoWidth,
              child: Image(
                  image:
                      Image.asset("assets/bindr_images/Bindr_logo_.png").image),
            ),
            Container(
              width: MediaQuery.of(context).size.width * logoWidth,
              decoration: const BoxDecoration(
                color: gray,
                // border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                enabled: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Book Title, Author, or ISBN",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  suffixIconConstraints:
                      const BoxConstraints(maxHeight: 30, maxWidth: 40),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: gray,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      /*boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            blurStyle: BlurStyle.solid),
                      ], */
                    ),
                    child: IconButton(
                      onPressed: () {
                        search(currentSearchText, context);
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ),
                onSubmitted: (String text) {
                  search(text, context);
                },
                onChanged: (String text) {
                  currentSearchText = text;
                },
                //   onTapOutside: (PointerDownEvent pde) {
                //     FocusScope.of(context).unfocus();
                //   },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Text(
                "Hi <USERNAME FROM DATABASE HERE>!",
                style: TextStyle(
                    color: pink, fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
              //
              radius: 120,
              backgroundImage: AssetImage(
                "assets/bindr_images/Bindr_logo_.png",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.co_present_rounded,
                color: pink,
              ),
              title: const Text("PROFILE",
                  style: TextStyle(color: pink, fontSize: 20)),
              onTap: () {}, // waiting for bookmarks page
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_border_rounded, color: pink),
              title: const Text("BOOKMARK",
                  style: TextStyle(color: pink, fontSize: 20)),
              onTap: () {}, // waiting for bookmarks page
            ),
            ListTile(
              leading: const Icon(Icons.book_outlined, color: pink),
              title: const Text("SELL BOOK",
                  style: TextStyle(color: pink, fontSize: 20)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SellScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined, color: pink),
              title: const Text("SETTINGS",
                  style: TextStyle(color: pink, fontSize: 20)),
              onTap: () {}, // waiting for settings page
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_rounded, color: pink),
              title: const Text("SIGN OUT",
                  style: TextStyle(color: pink, fontSize: 20)),
              onTap: () async {
                await auth.signOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Welcome()));
              },
            )
          ],
        ),
      ),
    ));
  }

  void search(String text, BuildContext context) {
    debugPrint("Searching for: " + text);
    FocusScope.of(context).unfocus();
  }
}
