// import 'dart:js';
import 'package:bindr_app/items/bindr_drawer.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/search_screen/search_results.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class SearchScreen extends StatelessWidget {
  //amount of the device screen height that the logo should be pushed down
  // default is .15
  final double logoYOffset;
  final double logoWidth;

  SearchScreen({super.key, this.logoYOffset = .15, this.logoWidth = .75});

  String currentSearchString = "";

  final auth = AuthService(); //Temporary

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: logobackground,
        elevation: 0,
      ),
      drawer: BindrDrawer(currentPage: "SEARCH"),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // dragStartBehavior: DragStartBehavior.down,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * logoYOffset,
            ),
            SizedBox(
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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (currentSearchString.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchResults(
                                    searchString: currentSearchString,
                                  )));
                          currentSearchString = currentSearchString;
                        } else {
                          /////pop up
                          debugPrint("ERROR: Search String is empty");
                        }
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                      padding: const EdgeInsets.all(0),
                    ),
                  ),
                ),
                onSubmitted: (String text) async {
                  FocusScope.of(context).unfocus();
                  if (currentSearchString.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchResults(
                              searchString: currentSearchString,
                            )));
                  } else {
                    /////pop up
                    debugPrint("ERROR: Search String is empty");
                  }
                  currentSearchString = currentSearchString;
                },
                onChanged: (String text) {
                  currentSearchString = text;
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // static Future<MaterialPageRoute<dynamic>> search(
  //     String searchText, BuildContext context, List<Object?> startAfter) async {
  //   FocusScope.of(context).unfocus();
  //   List<Post> postList = await PostSerialize().searchDB(
  //       searchText.toLowerCase(), pageLimit,
  //       orderBy: "last_modified", descending: true, startPoint: startAfter);
  //   return MaterialPageRoute(
  //       builder: (context) => SearchResults(
  //             searchString: searchText,
  //             lastPost: startAfter,
  //             postList: postList,
  //           ));
  // }
}
