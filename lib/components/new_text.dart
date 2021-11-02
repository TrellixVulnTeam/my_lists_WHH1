import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/list_field.dart';
import 'package:my_lists/models/item.dart';

final db = FirebaseFirestore.instance;

late User loggedInUser;
String? title;
late String text;

class NewText extends StatefulWidget {
  static const String id = 'new_list';

  @override
  _NewTextState createState() => _NewTextState();
}

class _NewTextState extends State<NewText> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _textEditingController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextField(
                    style: TextStyle(fontSize: 20.0),
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: _textEditingController,
                    autofocus: true,
                    maxLines: null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: kPrimaryTextColour, fontSize: 25.0),
                      ),
                      onPressed: () {
                        title = null;
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: TextButton(
                          child: Text(
                            'Create Note',
                            style: TextStyle(
                                color: kPrimaryTextColour, fontSize: 25.0),
                          ),
                          onPressed: () {
                            text = _textEditingController.text;

                            title == null ? title = 'Untitled' : title = title;
                            createNote(title);
                            title = null;
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SizedBox(height: 10.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createNote(title) {
    CollectionReference docs =
        db.collection('users').doc(loggedInUser.uid).collection('docs');

    Future<void> creatingNote() {
      return docs
          // use add instead of set to prevent overwriting
          .add({
            'title': title,
            'body': text,
            'created at': FieldValue.serverTimestamp(),
            'created by': loggedInUser.email,
            'type': 'note',
          })
          .then((value) => print("Note Added with title: $title"))
          .catchError((error) => print("Failed to add note: $error"));
    }

    creatingNote();
  }
}
