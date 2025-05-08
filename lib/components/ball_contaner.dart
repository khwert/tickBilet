import 'package:flutter/material.dart';

Widget ballContainer(Color color) {
  return Container(
    margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
    decoration: BoxDecoration(
        border: Border.all(color: color, width: 5),
        borderRadius: const BorderRadius.all(Radius.circular(100))),
  );
}
