import 'package:flutter/material.dart';
import 'package:ticketproject/constant/colors.dart';

class RadioCheck extends StatefulWidget {
  final Function updateDate;
  const RadioCheck({super.key, required this.updateDate});

  @override
  State<RadioCheck> createState() => _RadioCheckState();
}

class _RadioCheckState extends State<RadioCheck> {
  List<String> gunyar = ["Bugün", "Yarın"];
  String? selectedValue = "Bugün";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: gunyar
              .map((item) => Row(
                    children: [
                      Radio(
                        fillColor:
                            WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return interactiveColor;
                          }
                          return secondaryTextColor;
                        }),
                        value: item,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                          selectedValue == "Bugün"
                              ? widget.updateDate(DateTime.now())
                              : widget.updateDate(
                                  DateTime.now().add(const Duration(days: 1)));
                        },
                      ),
                      Text(item,
                          textScaler: const TextScaler.linear(1.0),
                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ))
              .toList()),
    );
  }
}
