import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  late final bool isDone;
  late final String item;
  // late final Function checkboxCallback;

  // Constructor initialises the variables
  ItemTile({required this.isDone, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item,
          style: TextStyle(
              decoration: isDone ? TextDecoration.lineThrough : null)),
    );
  }
}
