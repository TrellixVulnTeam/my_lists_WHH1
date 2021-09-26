import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';

class ListField extends StatelessWidget {
  // Used to grab content of TextField
  final Function(String) onChange;

  ListField({required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        onChanged: onChange,
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
