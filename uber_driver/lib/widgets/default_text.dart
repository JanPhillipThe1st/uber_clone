import 'package:flutter/material.dart';

import '../utils/app_info.dart';

class DefaultText extends StatefulWidget {
  const DefaultText({ key, this.text, required this.width});
  final text;
  final double width;
  @override
  State<DefaultText> createState() => _DefaultTextState();
}

class _DefaultTextState extends State<DefaultText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Text(
        widget.text,
        textAlign: TextAlign.left,
        style: defaultStyle,
      ),
    );
  }
}
