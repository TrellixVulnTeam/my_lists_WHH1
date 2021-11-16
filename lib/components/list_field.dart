import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';

class ListField extends StatelessWidget {
  final controller;
  final FocusNode? lineFocus;

  ListField({this.controller, this.lineFocus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        controller: controller,
        focusNode: lineFocus,
        autofocus: true,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryTextColour),
          ),
        ),
        cursorColor: kPrimaryTextColour,
      ),
    );
  }
}
