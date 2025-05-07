import 'package:flutter/material.dart';
import 'package:ticketproject/constant/colors.dart';

class CustomTextFormSign extends StatelessWidget {
  final String hint;
  final TextEditingController mycontroller;
  final String? Function(String?) valida;
  const CustomTextFormSign(
      {super.key,
      required this.hint,
      required this.mycontroller,
      required this.valida});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: valida,
        controller: mycontroller,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: secondaryTextColor, fontSize: 15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
