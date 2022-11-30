import 'package:bindr_app/items/bindr_drawer.dart';
import 'package:bindr_app/models/DatabaseRepresentations.dart';
import 'package:bindr_app/services/get_info.dart';
import 'package:intl/intl.dart';
import 'package:bindr_app/items/rounded_input_field.dart';
import 'package:bindr_app/search_screen/search_screen.dart';
import 'package:bindr_app/sell_screen/final_sell.dart';
import 'package:bindr_app/services/validate.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';

class SellScreen extends StatefulWidget {
  final Post? currentPost;
  const SellScreen({this.currentPost, super.key});

  @override
  State<SellScreen> createState() => _SellScreenState(currentPost);
}

class _SellScreenState extends State<SellScreen> {
  final TextEditingController _textEditingControllerPT =
      TextEditingController();
  final TextEditingController _textEditingControllerI = TextEditingController();
  final TextEditingController _textEditingControllerC = TextEditingController();
  final TextEditingController _textEditingControllerPR =
      TextEditingController();

  String errorTextPT = "", errorTextI = "", errorTextC = "", errorTextPR = "";

  String postTitle = "";

  String isbn = "";

  String description = "";

  String price = "";

  String _dropdownValue = "SELECT CONDITION";

  Validate validator = Validate();

  Post? currentPost;
  _SellScreenState(this.currentPost) {
    if (currentPost != null) {
      _textEditingControllerC.text = conditionToString[currentPost!.condition]!;
      _dropdownValue = conditionToString[currentPost!.condition]!;
      _textEditingControllerI.text = currentPost!.isbn;
      isbn = currentPost!.isbn;
      _textEditingControllerPR.text = currentPost!.price;
      price = currentPost!.price;
      _textEditingControllerPT.text = currentPost!.title;
      postTitle = currentPost!.title;
    }
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  listBook(BuildContext context, {bool updateExisting = false}) async {
    if (validator.validateISBN(isbn) &&
        validator.validatePrice(price) &&
        validator.validateTitle(postTitle) &&
        _dropdownValue != "") {
      Map<String, Object?>? info = await getInfo(isbn);
      if (info == null) {
        errorTextI =
            "Error: ISBN not found, please make sure you typed it in correctly.";
      } else {
        String finalPrice = formatPrice(price);
        if (info["Image"] == null) {
          info["Image"] =
              "http://www.nipponniche.com/wp-content/uploads/2021/04/fentres-pdf.jpeg";
        }
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => Confirm(
                    postTitle: postTitle,
                    isbn: info["ISBN"],
                    bookName: info["Name"],
                    author: info["Author"],
                    cond: _dropdownValue,
                    description: description,
                    price: finalPrice,
                    pic: info["Image"],
                    existingDocId: currentPost?.documentID,
                  )),
        );
      }
    } else {
      if (!validator.validateISBN(isbn)) {
        errorTextI = "Error: Please enter a valid ISBN-10 or ISBN-13";
      }
      if (!validator.validatePrice(price)) {
        errorTextPR =
            "Error: Please enter a price in USD format less than \$9999.99";
        print("Invalid price: $price");
      }
      if (!validator.validateTitle(postTitle)) {
        errorTextPT = "Error: Title must be at least 3 characters long";
      }
      if (_dropdownValue == "" || _dropdownValue == "SELECT CONDITION") {
        errorTextC = "Error: Please select a condition value";
      }
    }
    setState(() {
      _textEditingControllerC.text = _dropdownValue;
      _textEditingControllerI.text = isbn;
      _textEditingControllerPR.text = price;
      _textEditingControllerPT.text = postTitle;
      errorTextC = errorTextC;
      errorTextI = errorTextI;
      errorTextPR = errorTextPR;
      errorTextPT = errorTextPT;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerC.dispose();
    _textEditingControllerPR.dispose();
    _textEditingControllerPT.dispose();
    _textEditingControllerI.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: logobackground,
          elevation: 0,
        ),
        backgroundColor: logobackground,
        drawer: (currentPost == null)
            ? BindrDrawer(currentPage: "SELL BOOK")
            : null,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: size.height * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    child: const Text(
                      "SELL YOUR BOOK",
                      style: TextStyle(color: pink, fontSize: 35),
                    )),
                rounded_input_field(
                  controller: _textEditingControllerPT,
                  errorText: errorTextPT,
                  maxLength: 50,
                  hide: false,
                  hintText: "ENTER TITLE OF LISTING",
                  icon: Icons.title_sharp,
                  onChanged: (value) {
                    setState(() {
                      errorTextPT = "";
                    });
                    postTitle = value;
                  },
                  // onSubmitted: (p0) => listBook(context),
                ),
                rounded_input_field(
                  controller: _textEditingControllerI,
                  errorText: errorTextI,
                  maxLength: 13,
                  hide: false,
                  hintText: "ENTER ISBN",
                  icon: Icons.book_sharp,
                  onChanged: (value) {
                    setState(() {
                      errorTextI = "";
                    });
                    isbn = value;
                  },
                  // onSubmitted: (p0) => listBook(context),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: gray,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: gray,
                              ),
                              child: DropdownButton<String>(
                                value: _dropdownValue,
                                isExpanded: true,
                                hint: const Text("SELECT CONDITION",
                                    style: TextStyle(color: logobackground)),
                                items: const [
                                  DropdownMenuItem(
                                    value: "SELECT CONDITION",
                                    child: Text("SELECT CONDITION",
                                        style:
                                            TextStyle(color: logobackground)),
                                  ),
                                  DropdownMenuItem(
                                    value: "NEW",
                                    child: Text("NEW",
                                        style:
                                            TextStyle(color: logobackground)),
                                  ),
                                  DropdownMenuItem(
                                    value: "GREAT",
                                    child: Text("GREAT",
                                        style:
                                            TextStyle(color: logobackground)),
                                  ),
                                  DropdownMenuItem(
                                    value: "GOOD",
                                    child: Text("GOOD",
                                        style:
                                            TextStyle(color: logobackground)),
                                  ),
                                  DropdownMenuItem(
                                    value: "BAD",
                                    child: Text("BAD",
                                        style:
                                            TextStyle(color: logobackground)),
                                  ),
                                  DropdownMenuItem(
                                    value: "POOR",
                                    child: Text("POOR",
                                        style:
                                            TextStyle(color: logobackground)),
                                  ),
                                ],
                                onChanged: dropdownCallback,
                              )),
                          if (errorTextC != "") ...{
                            Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Text(
                                  errorTextC,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 225, 72, 61),
                                      fontSize: 12),
                                ))
                          }
                        ])), //drop down button for condition of book
                rounded_input_field(
                  maxLength: 200,
                  hide: false,
                  hintText: "ADDITIONAL DETAILS (optional)",
                  icon: Icons.format_align_left_sharp,
                  onChanged: (value) {
                    description = value;
                  },
                  controller: TextEditingController(
                      text: currentPost?.description ?? ""),
                  // onSubmitted: (p0) => listBook(context),
                ),

                rounded_input_field(
                  controller: _textEditingControllerPR,
                  errorText: errorTextPR,
                  maxLength: 7,
                  hide: false,
                  hintText: "ENTER PRICE",
                  icon: Icons.attach_money,
                  onChanged: (value) {
                    setState(() {
                      errorTextPR = "";
                    });
                    price = value;
                  },
                  // onSubmitted: (p0) => listBook(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                  onPressed: () => listBook(context,
                      updateExisting: currentPost == null ||
                          currentPost!.documentID == null),
                  child: Text(
                    (currentPost == null ? "List Book" : "Update Listing"),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  child: const Text(
                    "GO HOME",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatPrice(String price) {
  final formatter = NumberFormat("#,##0.00", "en_US");
  return "\$${formatter.format(double.parse(price))}";
}
