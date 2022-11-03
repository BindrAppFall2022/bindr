import "package:bindr_app/items/constants.dart";
import 'package:flutter/material.dart';

class condition_drop extends StatefulWidget {
  @override
  condition_dropState createState() => condition_dropState();
}

class condition_dropState extends State {
  String? currcond;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: gray,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: gray,
            ),
            child: DropdownButton<String>(
              value: currcond,
              hint: const Text("SELECT CONDITION",
                  style: TextStyle(color: logobackground)),
              items: const [
                DropdownMenuItem(
                  value: "NEW",
                  child: Text("NEW", style: TextStyle(color: logobackground)),
                ),
                DropdownMenuItem(
                  value: "USED",
                  child: Text("USED", style: TextStyle(color: logobackground)),
                )
              ],
              onChanged: (value) {
                setState(() {
                  currcond = value;
                });
              },
            )));
  }
}
