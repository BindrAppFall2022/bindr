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
  int sortIndex = 0;
  List<String> sortArray = ["Date", "Price"];
  String sortPrice = '';

  bool descending = true;

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
        descending: descending, orderBy: 'last_modified', startPoint: lastPost);
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
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.065),
                      child: Container(
                          width: size.width * 0.10,
                          decoration: const BoxDecoration(
                              color: gray,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: PopupMenuButton(
                            icon: const Icon(Icons.filter_alt),
                            color: gray,
                            tooltip: "Sorting Options",
                            itemBuilder: ((context) {
                              const Text("Sort By");
                              return const [
                                PopupMenuItem(child: Text("Date")),
                                PopupMenuItem(child: Text("Price")),
                                PopupMenuItem(child: Text("Condition")),
                                PopupMenuItem(child: Text("Name")),
                              ];
                            }),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width:
                          MediaQuery.of(context).size.width * widget.barWidth,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
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
                                                searchString:
                                                    currentSearchString,
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
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => SearchResults(
                                          searchString: currentSearchString,
                                        )));
                            currentSearchString = currentSearchString;
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
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(22.0),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: postList.length,
                      itemBuilder: ((context, index) {
                        return Material(
                          type: MaterialType.transparency,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ListTile(
                              //visualDensity: const VisualDensity(vertical: 4),
                              leading: SizedBox(
                                height: 300,
                                child: Image.network(postList[index].imageURL,
                                    //scale: 3.0,
                                    fit: BoxFit.fill),
                              ),
                              title: Column(
                                children: [
                                  Text(postList[index].title),
                                  Text(
                                      "Book Name: ${postList[index].bookName}"),
                                  Text(
                                      "Condition: ${conditionToString[postList[index].condition]!}"),
                                ],
                              ),
                              tileColor: gray,
                              trailing: Text(postList[index].price,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              focusColor:
                                  const Color.fromARGB(255, 83, 168, 238),
                              textColor: Colors.black,
                              onTap: () {}, /////
                            ),
                          ),
                        );
                      })),
                ),
              ]),
            )));
  }
}
