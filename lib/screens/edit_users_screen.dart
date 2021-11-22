import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';

class EditUsers extends StatelessWidget {
  static const String id = 'edit_users';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
          backgroundColor: kLightAccentColour,
        ),
      ),
    );
  }
}
