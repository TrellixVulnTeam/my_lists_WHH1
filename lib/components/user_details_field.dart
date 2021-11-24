import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';

class UserDetailsField extends StatelessWidget {
  UserDetailsField({
    this.label,
    this.content,
    required this.onChange,
  });

  final label;
  final content;
  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: kUsersTextFormFieldDecoration.copyWith(labelText: label),
        initialValue: content,
        style: TextStyle(fontSize: 25.0),
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}
