import 'package:flutter/material.dart';

import '../utils/app_info.dart';

class DefaultTextField extends StatefulWidget {
  const DefaultTextField(
      {key, this.hint, required this.controller, required this.obscure, required this.color});
  final hint;
  final bool obscure;
  final Color color;
  final TextEditingController controller;
  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      
      style: defaultStyle.copyWith(color: widget.color),
      obscureText: widget.obscure,
      decoration: InputDecoration(
        fillColor: widget.color,
        hintStyle: defaultStyle.copyWith(color: widget.color.withAlpha(50)),
        hintText: widget.hint,
      ),
    );
  }
}
