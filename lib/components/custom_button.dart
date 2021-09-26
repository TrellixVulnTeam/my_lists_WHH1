import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color colour;
  final VoidCallback onPress;
  final double radius;

  CustomButton(
      {required this.text,
      required this.colour,
      required this.onPress,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        text,
        style: TextStyle(color: kSecondaryTextColour),
      ),
      elevation: 2.0,
      height: 50,
      color: colour,
      onPressed: onPress,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
