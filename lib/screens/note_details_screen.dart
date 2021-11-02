import 'package:flutter/material.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User loggedInUser;

class NoteDetailsScreen extends StatefulWidget {
  late String noteBody;
  late String noteTitle;
  late String noteID;

  NoteDetailsScreen(
      {required this.noteBody, required this.noteTitle, required this.noteID});

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  void dispose() {
    widget.noteBody = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
        backgroundColor: kLightAccentColour,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              widget.noteTitle,
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(widget.noteBody),
          )
        ],
      ),
    );
  }
}
