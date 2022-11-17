import 'package:flutter/material.dart';

import '../items/constants.dart';

class SearchResults extends StatelessWidget {
  String currentSearchString;
  final _controllerSearchBar = TextEditingController();
  final double barWidth;
  String sortDate = 'new';
  String sortPrice = '';

  SearchResults(
      {super.key, required this.currentSearchString, this.barWidth = .75});

//List Values from firestore
//https://stackoverflow.com/questions/71844895/how-to-list-values-from-documents-in-flutter-firestore

//Toggle Buttons
//https://www.youtube.com/watch?v=v2QGS4UqaqA&ab_channel=JohannesMilke

//Small popup menu for sort button

//Something to think about: Recommendations while searching
//https://medium.flutterdevs.com/implement-searching-with-firebase-firestore-flutter-de7ebd53c8c9

  @override
  Widget build(BuildContext context) {
    _controllerSearchBar.text = currentSearchString;
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
              child: Column(children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * barWidth,
                  decoration: const BoxDecoration(
                    color: gray,
                    // border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    controller: _controllerSearchBar,
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
                        ),
                        child: IconButton(
                          onPressed: () {
                            //same as onSubmitted
                          },
                          icon: const Icon(
                            Icons.search,
                          ),
                          padding: const EdgeInsets.all(0),
                        ),
                      ),
                    ),
                    onSubmitted: (String text) {
                      //pushReplacement
                    },
                    onChanged: (String text) {
                      //update string
                    },
                  ),
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 10, /////results.length,
                    itemBuilder: ((context, index) {
                      return const ListTile(title: Text("Item"));
                    }))
              ]),
            )));
  }
}
