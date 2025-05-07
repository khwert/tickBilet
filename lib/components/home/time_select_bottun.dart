import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketproject/components/home/date_func.dart';
import 'package:ticketproject/components/home/radio_check.dart';
import 'package:ticketproject/constant/colors.dart';

class TimeSelectButton extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const TimeSelectButton({super.key, required this.onDateSelected});

  @override
  State<TimeSelectButton> createState() => _TimeSelectButtonState();
}

class _TimeSelectButtonState extends State<TimeSelectButton> {
  DateTime selectedDate = DateTime.now();

  void updateDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
    widget.onDateSelected(newDate); // notify parent
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMM', 'tr').format(selectedDate);
    String formattedDayDate = DateFormat('EEEE', 'tr').format(selectedDate);

    return Row(
      children: [
        InkWell(
          onTap: () {
            selectDate(context, selectedDate, updateDate);
          },
          borderRadius: BorderRadius.circular(10),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: generalBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: 75,
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Gidiş Tarih",
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: primaryTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formattedDayDate,
                    style: const TextStyle(
                      color: secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        RadioCheck(
          updateDate: updateDate,
        ),
      ],
    );
  }
}
