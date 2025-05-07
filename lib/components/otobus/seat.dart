import 'package:flutter/material.dart';

Widget seat(int? seatNumber, Color? color) {
  double circular = seatNumber == 0 ? 6 : 8;

  return Container(
    margin: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
    decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(circular),
            topLeft: Radius.circular(circular))),
    child: Center(child: Text(seatNumber == 0 ? "" : "$seatNumber")),
  );
}
