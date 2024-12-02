import 'package:flutter/material.dart';

class SecretTextform extends StatefulWidget {
  const SecretTextform(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.fKey,
      required this.controller_parent, required this.textColor});
  final String labelText;
  final TextEditingController controller;
  final GlobalKey<FormState> fKey;
  final TextEditingController? controller_parent;
  final Color textColor;
  @override
  State<SecretTextform> createState() => _SecretTextformState();
}

class _SecretTextformState extends State<SecretTextform> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.fKey,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: TextFormField(
          obscureText: obscureText,
          controller: widget.controller,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 179, 62, 121)),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 179, 62, 121), width: 3),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            labelText: widget.labelText,
            labelStyle: TextStyle(color: widget.textColor),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: obscureText
                  ?  Icon(Icons.visibility_off, color:Color.fromARGB(255, 165, 165, 165) ,)
                  :  Icon(Icons.visibility, color: Color.fromARGB(255, 165, 165, 165),),
            ),
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return "please , Enter ${widget.labelText}";
            }
            if (widget.labelText == "Confirm Password" &&
                widget.controller_parent != null) {
              if (val != widget.controller_parent!.text) {
                return "Password does not match";
              }
              return null;
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}
