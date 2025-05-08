import 'package:flutter/material.dart';

Widget customButton(Function()? onTap, Widget child, String text, Color? color,
    Color? buttonColor) {
  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          child,
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
