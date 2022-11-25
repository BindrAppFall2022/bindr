import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends PopupMenuItem<T> {
  final Color color;
  final IconData? iconData;

  const CustomPopupMenuItem({
    Key? key,
    T? value,
    void Function()? onTap,
    bool enabled = true,
    required Widget child,
    this.iconData,
    required this.color,
  }) : super(
            key: key,
            value: value,
            enabled: enabled,
            child: child,
            onTap: onTap);

  @override
  _CustomPopupMenuItemState<T> createState() => _CustomPopupMenuItemState<T>();
}

class _CustomPopupMenuItemState<T>
    extends PopupMenuItemState<T, CustomPopupMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          size: 30,
          widget.iconData,
          color: Colors.black,
        ),
        super.build(context)
      ]),
    );
  }
}
