import 'package:flutter/material.dart';

import 'default_text_field.dart';

class RegistrationInput extends StatefulWidget {
  const RegistrationInput({Key key, this.hintText, this.controller});

  final String hintText;
  final TextEditingController controller;
  @override
  State<RegistrationInput> createState() => _RegistrationInputState();
}

class _RegistrationInputState extends State<RegistrationInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            widget.hintText,
            style: TextStyle(fontFamily: "Poppins"),
          ),
          Container(
            width: 240,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: DefaultTextField(
              obscure: false,
              color: Colors.black,
              hint: widget.hintText,
              controller: widget.controller,
            ),
          ),
        ],
      ),
    );
  }
}
