import 'package:flutter/material.dart';

class CustomTextfrom extends StatelessWidget {
  const CustomTextfrom(
      {super.key,
        required this.labelText,
        required this.controller,
        required this.fKey, required this.textColor});

  final String labelText;
  final TextEditingController controller;
  final GlobalKey<FormState> fKey;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: fKey,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: textColor),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 179, 62, 121)),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 179, 62, 121), width: 3),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return "Please enter $labelText";
            }
            return null;
          },
        ),
      ),
    );
  }
}
