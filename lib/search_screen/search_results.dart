import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:flutter/material.dart';
import '../items/constants.dart';
import '../models/DatabaseRepresentations.dart';

class SearchResults extends StatefulWidget {
  final String searchString;
  final double barWidth;
  final int sortIndex;
  final bool descending;

  const SearchResults({
    super.key,
    required this.searchString,
    this.barWidth = .75,
    this.sortIndex = 0,
    this.descending = true,
  });

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final _controllerSearchBar = TextEditingController();

  String currentSearchString = "";

  int sortIndex = 0;
  late IconData sortIcon;
  List<String> sortArray = ["Date", "Price", "Condition", "Name"];
  List<IconData> sortIconArr = [
    Icons.arrow_upward_sharp,
    Icons.arrow_downward_sharp,
  ];

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
    sortIndex = widget.sortIndex;
    descending = widget.descending;
    if (descending) {
      sortIcon = Icons.arrow_downward_sharp;
    } else {
      sortIcon = Icons.arrow_upward_sharp;
    }
    sortIcon = (descending) ? sortIconArr[1] : sortIconArr[0];
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
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.025),
                      child: Container(
                          width: size.width * 0.10,
                          decoration: BoxDecoration(
                              color: (descending == true)
                                  ? const Color.fromARGB(255, 185, 51, 41)
                                  : const Color.fromARGB(255, 68, 171, 255),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  descending = !descending;
                                  sortIcon = (descending)
                                      ? sortIconArr[1]
                                      : sortIconArr[0];
                                });
                              },
                              icon: Icon(sortIcon))),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width *
                          widget.barWidth *
                          0.85,
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (postList.isNotEmpty || finishedLoading == false) {
                      return Container(
                          padding: const EdgeInsets.all(22.0),
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
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
                                      height: 100,
                                      child: Image.network(
                                          postList[index].imageURL,
                                          //scale: 3.0,
                                          fit: BoxFit.fill),
                                    ),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            postList[index].title,
                                            textScaleFactor: 1.5,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          RichText(
                                            textScaleFactor: 1.15,
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                const TextSpan(
                                                    text: "Book: ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text: postList[index]
                                                        .bookName,
                                                    style: const TextStyle(
                                                        color: Colors.black))
                                              ],
                                            ),
                                          ),
                                          RichText(
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                            const TextSpan(
                                                text: "Condition: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: conditionToString[
                                                    postList[index].condition]!,
                                                style: const TextStyle(
                                                    color: Colors.black))
                                          ])),
                                        ],
                                      ),
                                    ),
                                    tileColor: gray,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    trailing: Text(postList[index].price,
                                        textScaleFactor: 1.3,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    focusColor:
                                        const Color.fromARGB(255, 83, 168, 238),
                                    textColor: Colors.black,
                                    onTap: () {}, /////
                                  ),
                                ),
                              );
                            }),
                            separatorBuilder: (context, index) => const Divider(
                              height: 10,
                            ),
                          ));
                    } else {
                      return Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 40),
                            child: Text(
                              "No search results found for \"${widget.searchString}\", please consider changing your query.",
                              textScaleFactor: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: pink),
                            )),
                        Icon(
                          Icons.search_off_sharp,
                          size: size.height * 0.4,
                        )
                      ]);
                    }
                  },
                ),
              ]),
            )));
  }
}
