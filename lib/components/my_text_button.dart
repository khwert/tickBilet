import 'package:flutter/material.dart';
import 'package:ticketproject/constant/colors.dart';

Widget myTextButton(Function() onPressed, EdgeInsetsGeometry? padding,
    String buttonText, TextStyle? style, double radiosInt) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiosInt),
        ),
        backgroundColor: secondaryColor),
    child: Text(buttonText, style: style),
  );
}
