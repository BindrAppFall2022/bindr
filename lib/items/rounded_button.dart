import 'package:bindr_app/items/constants.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function()? press;
  final Color backgroundcolor;
  const RoundButton({
    Key? key,
    required this.text,
    this.press,
    this.backgroundcolor = pink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundcolor,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            onPressed: press,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
