// import 'dart:js';
import 'package:bindr_app/items/bindr_drawer.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:flutter/material.dart';
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
                      onPressed: () {
                        search(currentSearchText, context);
                      },
                      icon: const Icon(
                        Icons.search,
                      ),
                      padding: const EdgeInsets.all(0),
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
      drawer: BindrDrawer(),
    ));
  }

  void search(String text, BuildContext context) {
    debugPrint("Searching for: " + text);
    FocusScope.of(context).unfocus();
  }
}
