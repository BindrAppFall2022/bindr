// import 'dart:js';
import 'package:bindr_app/items/bindr_drawer.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:bindr_app/search_screen/search_results.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';

class SearchScreen extends StatefulWidget {
  //amount of the device screen height that the logo should be pushed down
  // default is .15
  final double logoYOffset;
  final double logoWidth;

  SearchScreen({super.key, this.logoYOffset = .15, this.logoWidth = .75});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controllerSearchBar = TextEditingController();
  String currentSearchString = "";
  String? errorTextSearch;

  @override
  void dispose() {
    super.dispose();
    _controllerSearchBar.dispose();
  }

  final auth = AuthService();
  //Temporary
  @override
  Widget build(BuildContext context) {
    _controllerSearchBar.text = currentSearchString;
    _controllerSearchBar.selection = TextSelection.fromPosition(
        TextPosition(offset: _controllerSearchBar.text.length));
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
              height: MediaQuery.of(context).size.height * widget.logoYOffset,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * widget.logoWidth,
              child: Image(
                  image:
                      Image.asset("assets/bindr_images/Bindr_logo_.png").image),
            ),
            Container(
              width: MediaQuery.of(context).size.width * widget.logoWidth,
              decoration: const BoxDecoration(
                color: gray,
                // border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: _controllerSearchBar,
                enabled: true,
                maxLength: 35,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  errorText: errorTextSearch,
                  hintText: "Enter Book Title, Author, or ISBN",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  suffixIconConstraints:
                      const BoxConstraints(maxHeight: 30, maxWidth: 40),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: gray,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
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
                          setState(() {
                            errorTextSearch =
                                "  ERROR: Search text cannot be empty";
                            currentSearchString = currentSearchString;
                          });
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
                    setState(() {
                      errorTextSearch = "  ERROR: Search text cannot be empty";
                      currentSearchString = currentSearchString;
                    });
                  }
                  currentSearchString = currentSearchString;
                },
                onChanged: (String text) {
                  setState(() {
                    currentSearchString = text;
                    errorTextSearch = null;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
