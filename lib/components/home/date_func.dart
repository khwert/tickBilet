import 'package:flutter/material.dart';
import 'package:ticketproject/constant/colors.dart';

Future<void> selectDate(
    BuildContext context, DateTime? selectedDate, Function updateDate) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              onPrimary: generalBackgroundColor,
              primary: interactiveColor,
              onSurface: primaryTextColor,
              surface: generalBackgroundColor),
        ),
        child: child!,
      );
    },
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2026),
  );

  if (pickedDate != null) {
    updateDate(pickedDate);
  }
}
