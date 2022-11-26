import 'package:bindr_app/controllers/DatabaseInteractionSkeleton.dart';
import 'package:bindr_app/items/custom_popup_menu_item.dart';
import 'package:flutter/material.dart';
import '../items/constants.dart';
import '../models/DatabaseRepresentations.dart';
import 'package:intl/intl.dart';

class SearchResults extends StatefulWidget {
  final String searchString;
  final double barWidth;
  final bool descending;
  final int currentFilterIndex;

  const SearchResults({
    super.key,
    required this.searchString,
    this.barWidth = .75,
    this.descending = true,
    this.currentFilterIndex = 0,
  });

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final TextEditingController _controllerSearchBar = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  late String currentSearchString;

  int itemsPerLoad = 10; //num_items before loading more

  late IconData sortIcon;
  List<String> orderByArray = [
    "last_modified",
    "price",
    "condition",
    "q_book_name"
  ];
  List<Color> filterColors = [gray, gray, gray, gray];
  late int currentFilterIndex;

  late String orderByKey;
  List<IconData> sortIconArr = [
    Icons.arrow_upward_sharp,
    Icons.arrow_downward_sharp,
  ];

  bool descending = true;

  final dateFormatter = DateFormat('yyyy-MM-dd');

  List<Object?> lastPost = [null];
  List<Post> postList = [];
  List<Post> fullData = [];
  int curDataIndex = 0;
  @override
  SearchResults get widget => super.widget;

  bool loading = false, finishedLoading = false;

  fetchDataInit() async {
    if (finishedLoading) {
      return;
    }
    setState(() {
      loading = true;
    });
    List<Post> newList = await PostSerialize().searchDB(
        currentSearchString, pageLimit,
        descending: descending, orderBy: orderByKey, startPoint: lastPost);
    if (newList.isNotEmpty) {
      fullData.addAll(newList);
      sortData(key: orderByKey, descending: descending);
      if (fullData.length >= itemsPerLoad) {
        postList.addAll(
            fullData.sublist(curDataIndex, curDataIndex + itemsPerLoad));
        curDataIndex += itemsPerLoad;
      } else {
        postList.addAll(fullData);
        curDataIndex += fullData.length;
      }
    }
    setState(() {
      loading = false;
      finishedLoading = newList.isEmpty;
    });
  }

  fetchData() async {
    if (finishedLoading) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    List<Post> newList = postList.length >= pageLimit
        ? []
        : () {
            List<Post> tempList;
            if (fullData.length - curDataIndex >= itemsPerLoad) {
              tempList =
                  fullData.sublist(curDataIndex, curDataIndex + itemsPerLoad);
              curDataIndex += itemsPerLoad;
            } else {
              tempList = fullData.sublist(curDataIndex,
                  curDataIndex + (fullData.length - curDataIndex));
              curDataIndex += fullData.length - curDataIndex;
            }
            return tempList;
          }();
    if (newList.isNotEmpty) {
      postList.addAll(newList);
    }
    setState(() {
      loading = false;
      finishedLoading = newList.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    currentSearchString = widget.searchString.toLowerCase();
    descending = widget.descending;
    currentFilterIndex = widget.currentFilterIndex;
    filterColors[currentFilterIndex] = Colors.blue;
    orderByKey = orderByArray[currentFilterIndex];
    sortIcon =
        (descending) ? Icons.arrow_downward_sharp : Icons.arrow_upward_sharp;
    sortIcon = (descending) ? sortIconArr[1] : sortIconArr[0];
    fetchDataInit();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        fetchData();
      }
    });
    _scrollController.addListener(() {
      setState(() {
        _showBackToTopButton = (_scrollController.offset >= 200) ? true : false;
      });
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 800), curve: Curves.linear);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerSearchBar.dispose();
    _scrollController.dispose();
  }

  sortData({required String key, required bool descending}) {
    fullData.sort(((a, b) =>
        a.toMapComparable()[key]!.compareTo(b.toMapComparable()[key])));
    if (descending) {
      fullData = fullData.reversed.toList();
    }
    postList = fullData.sublist(0, curDataIndex);
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
            floatingActionButton: _showBackToTopButton == false
                ? null
                : FloatingActionButton(
                    onPressed: _scrollToTop,
                    backgroundColor: pink,
                    child: const Icon(Icons.arrow_upward),
                  ),
            body: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
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
                            offset: Offset(0, size.height * 0.05),
                            icon: const Icon(Icons.filter_alt),
                            color: gray,
                            tooltip: "Sorting Options",
                            itemBuilder: ((context) {
                              const Text("Sort By");
                              return [
                                CustomPopupMenuItem(
                                  color: filterColors[0],
                                  iconData: Icons.calendar_month,
                                  onTap: () {
                                    setState(() {
                                      orderByKey = orderByArray[0];
                                      sortData(
                                          key: orderByKey,
                                          descending: descending);
                                      filterColors[currentFilterIndex] = gray;
                                      currentFilterIndex = 0;
                                      filterColors[currentFilterIndex] =
                                          Colors.blue;
                                    });
                                  },
                                  child: const Text("Date"),
                                ),
                                CustomPopupMenuItem(
                                  color: filterColors[1],
                                  iconData: Icons.attach_money,
                                  onTap: () {
                                    setState(() {
                                      orderByKey = orderByArray[1];
                                      sortData(
                                          key: orderByKey,
                                          descending: descending);
                                      filterColors[currentFilterIndex] = gray;
                                      currentFilterIndex = 1;
                                      filterColors[currentFilterIndex] =
                                          Colors.blue;
                                    });
                                  },
                                  child: const Text("Price"),
                                ),
                                CustomPopupMenuItem(
                                  color: filterColors[2],
                                  iconData: Icons.label,
                                  onTap: () {
                                    setState(() {
                                      orderByKey = orderByArray[2];
                                      sortData(
                                          key: orderByKey,
                                          descending: descending);
                                      filterColors[currentFilterIndex] = gray;
                                      currentFilterIndex = 2;
                                      filterColors[currentFilterIndex] =
                                          Colors.blue;
                                    });
                                  },
                                  child: const Text("Condition"),
                                ),
                                CustomPopupMenuItem(
                                  color: filterColors[3],
                                  iconData: Icons.title,
                                  onTap: () {
                                    setState(() {
                                      orderByKey = orderByArray[3];
                                      sortData(
                                          key: orderByKey,
                                          descending: descending);
                                      filterColors[currentFilterIndex] = gray;
                                      currentFilterIndex = 3;
                                      filterColors[currentFilterIndex] =
                                          Colors.blue;
                                    });
                                  },
                                  child: const Text("Name"),
                                ),
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
                                  sortData(
                                      key: orderByKey, descending: descending);
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
                          hintText: "Enter Title, Author, or ISBN",
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
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) => SearchResults(
                                                searchString:
                                                    currentSearchString,
                                                currentFilterIndex:
                                                    currentFilterIndex,
                                                descending: descending,
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
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => SearchResults(
                                          searchString: currentSearchString,
                                          currentFilterIndex:
                                              currentFilterIndex,
                                          descending: descending,
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
                  ],
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (postList.isNotEmpty || finishedLoading == false) {
                      return Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Stack(children: [
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  postList.length + ((finishedLoading) ? 1 : 0),
                              itemBuilder: ((context, index) {
                                if (index < postList.length) {
                                  return Material(
                                    type: MaterialType.transparency,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Image.network(
                                              postList[index].imageURL,
                                              height: 140,
                                              width: 120,
                                            ),
                                          ),
                                          Positioned(
                                            top: 148,
                                            left: 300,
                                            child: Text(dateFormatter.format(
                                                postList[index]
                                                    .lastModified
                                                    .toDate())),
                                          ),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minHeight: 170),
                                            child: ListTile(
                                              leading: const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 60,
                                                ),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      postList[index].title,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textScaleFactor: 1.5,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    RichText(
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textScaleFactor: 1.15,
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: TextSpan(
                                                        children: <TextSpan>[
                                                          const TextSpan(
                                                              text: "Book: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text: postList[
                                                                      index]
                                                                  .bookName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: <
                                                                TextSpan>[
                                                      const TextSpan(
                                                          text: "Condition: ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text: conditionToString[
                                                              postList[index]
                                                                  .condition]!,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                    ])),
                                                  ],
                                                ),
                                              ),
                                              tileColor: gray,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              trailing: SizedBox(
                                                width: size.width * 0.17,
                                                child: Text(
                                                    postList[index].price,
                                                    textScaleFactor: () {
                                                  if (postList[index]
                                                          .price
                                                          .length >
                                                      8) {
                                                    return 1.0;
                                                  } else if (postList[index]
                                                          .price
                                                          .length >
                                                      6) {
                                                    return 1.2;
                                                  } else {
                                                    return 1.3;
                                                  }
                                                }(),
                                                    textAlign: TextAlign.right,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              focusColor: const Color.fromARGB(
                                                  255, 83, 168, 238),
                                              textColor: Colors.black,
                                              onTap: () {}, /////
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: Text(
                                    "End of Results",
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        color: pink),
                                  ));
                                }
                              }),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 10,
                              ),
                            ),
                            if (loading) ...[
                              Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: SizedBox(
                                      width: constraints.maxWidth,
                                      height: 80,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      )))
                            ],
                          ]));
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
