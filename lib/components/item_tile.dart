import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';

class ItemTile extends StatelessWidget {
  final bool isDone;
  late final String name;
  final void Function() onTapped;

  // Constructor initialises the variables
  ItemTile({required this.isDone, required this.name, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: kPrimaryTextColour,
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      onTap: onTapped,
    );
  }
}
