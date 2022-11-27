import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';

class rounded_input_field extends StatelessWidget {
  final bool hide;
  final String? hintText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final String? errorText;

  const rounded_input_field({
    Key? key,
    required this.hide,
    this.hintText,
    this.icon,
    this.onChanged,
    this.maxLength,
    this.onSubmitted,
    this.controller,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Input_text_field(
        child: TextField(
      controller: controller,
      maxLength: maxLength,
      obscureText: hide,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        counterText: '',
        icon: Icon(
          icon,
          color: logobackground,
        ),
        errorText: errorText,
        errorMaxLines: 2,
        errorStyle: TextStyle(height: 0.9),
        hintText: hintText,
        border: InputBorder.none,
      ),
    ));
  }
}

class Input_text_field extends StatelessWidget {
  final Widget? child;
  const Input_text_field({
    Key? key,
    this.child,
  }) : super(key: key);

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
      child: child,
    );
  }
}
