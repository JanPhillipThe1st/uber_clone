import 'package:flutter/material.dart';
import '../utils/text_utilities.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget(
      {Key? key,
      this.hinttext,
      this.hintTextColor,
      this.textColor,
      this.obscured,
      required this.controller,
      this.color,
      required this.onchange})
      : super(key: key);
  String? hinttext;
  bool? obscured = false;
  TextEditingController controller;
  Color? color;
  Color? hintTextColor, textColor;
  void Function(String) onchange;
  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
        decoration: ShapeDecoration(
            color: widget.color != null ? widget.color : Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: borderColor))),
        child: TextField(
          obscureText: widget.obscured != null ? widget.obscured! : false,
          onChanged: widget.onchange,
          controller: widget.controller,
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: widget.textColor ?? textColor),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hinttext,
              hintStyle: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: widget.hintTextColor == null
                      ? textColor.withAlpha(200)
                      : widget.hintTextColor)),
        ));
  }
}
