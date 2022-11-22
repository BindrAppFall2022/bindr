import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:flutter/material.dart';

import '../items/constants.dart';
import '../models/DatabaseRepresentations.dart';

class SearchResults extends StatefulWidget {
  final String searchString;
  final double barWidth;

  const SearchResults({
    super.key,
    required this.searchString,
    this.barWidth = .75,
  });

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final _controllerSearchBar = TextEditingController();

  String currentSearchString = "";

  String sortDate = 'new';

  String sortPrice = '';

  List<Object?> lastPost = [null];
  List<Post> postList = [];

  @override
  SearchResults get widget => super.widget;

  bool loading = false, finishedLoading = false;
  fetchData() async {
    if (finishedLoading) {
      return;
    }
    setState(() {
      loading = true;
    });
    List<Post> newList = await PostSerialize().searchDB(
        widget.searchString, pageLimit,
        descending: true, orderBy: 'last_modified', startPoint: lastPost);
    if (newList.isNotEmpty) {
      postList.addAll(newList);
      lastPost = [postList[postList.length - 1]];
    }
    setState(() {
      loading = false;
      finishedLoading = newList.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    currentSearchString = widget.searchString;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    _controllerSearchBar.text = widget.searchString;
    Size size = MediaQuery.of(context).size;
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
                  width: MediaQuery.of(context).size.width * widget.barWidth,
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
                      suffixIconConstraints: BoxConstraints(
                          maxHeight: size.height * 0.2,
                          maxWidth: size.width * 0.2),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          color: gray,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            //same as onSubmitted
                            FocusScope.of(context).unfocus();
                            if (currentSearchString.isNotEmpty) {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => SearchResults(
                                            searchString: currentSearchString,
                                          )));
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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => SearchResults(
                                  searchString: currentSearchString,
                                )));
                      } else {
                        /////pop up
                        debugPrint("ERROR: Search String is empty");
                      }
                    },
                    onChanged: (String text) {
                      currentSearchString = text;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(22.0),
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: postList.length,
                      itemExtent: 200,
                      itemBuilder: ((context, index) {
                        //leading: image
                        //title: book_title
                        //trailing: price
                        return ListTile(
                          leading: Image.network(postList[index].imageURL,
                              fit: BoxFit.fill),
                          title: Text(postList[index].bookName),
                          tileColor: gray,
                          trailing: Text("\$${postList[index].price}"),
                          hoverColor: pink,
                          textColor: Colors.black,
                          //onTap: ,
                        );
                      })),
                ),
              ]),
            )));
  }
}
