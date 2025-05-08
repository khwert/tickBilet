import 'package:company_dashboard/components/func/date_func.dart';
import 'package:company_dashboard/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArrivalTimeSelectButton extends StatefulWidget {
  const ArrivalTimeSelectButton({super.key});

  @override
  State<ArrivalTimeSelectButton> createState() =>
      ArrivalTimeSelectButtonState();
}

class ArrivalTimeSelectButtonState extends State<ArrivalTimeSelectButton> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  void updateTime(TimeOfDay newTime) {
    setState(() {
      selectedTime = newTime;
    });
  }

  DateTime getCombinedDateTime() {
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMM', 'tr').format(selectedDate);
    String formattedDayDate = DateFormat('EEEE', 'tr').format(selectedDate);
    String formattedTime =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: mainColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              selectDate(context, selectedDate, updateDate);
            },
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            child: SizedBox(
              height: 75,
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Varış Tarihi",
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  Text(formattedDate,
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text(formattedDayDate,
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              selectTime(selectedTime, context, updateTime);
            },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: SizedBox(
              height: 75,
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Varış Saati ⏱",
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  Text(formattedTime,
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
