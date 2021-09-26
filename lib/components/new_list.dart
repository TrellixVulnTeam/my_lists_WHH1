import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/list_field.dart';

final db = FirebaseFirestore.instance;

List<Widget> listItems = [
  ListField(onChange: (val) => print(val)),
];

class NewList extends StatefulWidget {
  static const String id = 'new_list';

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  @override
  void dispose() {
    super.dispose();
    listItems = [];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Card(
          color: kLightAccentColour,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                child: TextField(
                  style: TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                      hintText: 'Title', border: InputBorder.none),
                ),
              ),
              ListField(
                onChange: (val) => print(val),
              ),
              ListView(
                shrinkWrap: true,
                children: listItems,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _addLine();
                      setState(() {});
                    },
                    child: Icon(
                      Icons.add,
                      color: kPrimaryTextColour,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: kPrimaryTextColour, fontSize: 25.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        listItems = [];
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Create List',
                        style: TextStyle(
                            color: kPrimaryTextColour, fontSize: 25.0),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _addLine() {
  // .. notation is cascade operator, used to not repeat 'listItems'. This is equivalent to the next 2 lines commented out
  listItems = List.from(listItems)
    ..add(ListField(
      onChange: (val) => print(val),
    ));
  // listItems = List.from(listItems);
  // listItems.add(ListField());
}
