import 'package:company_dashboard/constant/color.dart';
import 'package:flutter/material.dart';

Future<void> selectDate(
    BuildContext context, DateTime? selectedDate, Function updateDate) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
              onPrimary: mainColor,
              primary: secondaryColor,
              onSurface: secondaryColor,
              surface: mainColor),
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

Future<void> selectTime(
    TimeOfDay initialTime, BuildContext context, Function updateTime) async {
  final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
              onPrimary: mainColor,
              primary: secondaryColor,
              onSurface: secondaryColor,
              surface: mainColor),
          textTheme: TextTheme(
            titleLarge: TextStyle(color: secondaryColor),
            bodyLarge: TextStyle(color: secondaryColor),
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        ),
      );
    },
  );

  if (time != null) {
    updateTime(time);
  }
}
