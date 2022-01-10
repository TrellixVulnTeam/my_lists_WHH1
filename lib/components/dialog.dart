import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:my_lists/constants.dart';

void showCustomDialog(String message) {
  SmartDialog.show(
    isLoadingTemp: false,
    widget: Container(
      height: 80,
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(color: kPrimaryTextColour, fontSize: 25.0),
      ),
    ),
  );
}
