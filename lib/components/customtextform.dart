import 'package:company_dashboard/constant/color.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  final String hint;
  final TextEditingController mycontroller;
  final String? Function(String?) valida;
  final Icon icon;
  final int? maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  const CustomTextForm({
    super.key,
    required this.hint,
    required this.mycontroller,
    required this.valida,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: widget.valida,
        obscureText: _obscureText,
        controller: widget.mycontroller,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: widget.icon,
          prefixIconColor: mainColor,
          hintStyle: const TextStyle(color: mainColor, fontSize: 15),
          fillColor: secondaryColor,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: mainColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
