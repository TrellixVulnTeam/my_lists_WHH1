import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/list_field.dart';

final db = FirebaseFirestore.instance;

late User loggedInUser;
late String title;
late String item;

List<Widget> listFields = [
  ListField(
    onChange: (value) => item = value,
  ),
];

List<String> listItems = [];

class NewList extends StatefulWidget {
  static const String id = 'new_list';

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      loggedInUser = currentUser;
    }
  }

  @override
  void dispose() {
    super.dispose();
    listFields = [];
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
                  onChanged: (value) {
                    title = value.trim();
                  },
                ),
              ),
              ListField(
                onChange: (value) => item = value,
              ),
              ListView(
                shrinkWrap: true,
                children: listFields,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _addItem();
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
                        listFields = [];
                        listItems = [];
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Create List',
                        style: TextStyle(
                            color: kPrimaryTextColour, fontSize: 25.0),
                      ),
                      onPressed: () {
                        _addItem();
                        createList(title);
                        Navigator.pop(context);
                      },
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
  listFields = List.from(listFields)
    ..add(
      ListField(
        onChange: (value) => item = value,
      ),
    );
  // listItems = List.from(listItems);
  // listItems.add(ListField());
}

void _addItem() {
  listItems = List.from(listItems);
  listItems.add(item);
}

void createList(title) {
  DocumentReference lists = db
      .collection('users')
      .doc(loggedInUser.uid)
      .collection('lists')
      .doc(title);

  Future<void> creatingList() {
    return lists
        .set({
          'title': title,
          'body': listItems,
          'created at': FieldValue.serverTimestamp(),
          'created by': loggedInUser.email,
        })
        .then((value) => print("Report Added"))
        .catchError((error) => print("Failed to add report: $error"));
  }

  creatingList();
}
