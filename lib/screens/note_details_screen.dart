import 'package:flutter/material.dart';
import 'package:my_lists/components/center_text.dart';
import 'package:my_lists/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/models/models.dart';
import 'package:provider/provider.dart';
import 'package:my_lists/components/docs_list.dart';

final db = FirebaseFirestore.instance;
late User loggedInUser;
bool editOn = false;
bool saveReady = false;
late String editedText;

class NoteDetailsScreen extends StatefulWidget {
  final noteID;

  NoteDetailsScreen({this.noteID});

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  void initState() {
    editOn = false;
    saveReady = false;
    counter = 0;
    super.initState();
  }

  TextEditingController _controller = TextEditingController();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: db
            .collection('families')
            .doc(userData.family)
            .collection('docs')
            .doc(noteID)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _controller.text = snapshot.data['body'];
            // Get the cursor at the end of the existing text in the TextField
            _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length));
            return Scaffold(
              appBar: AppBar(
                title: Text('My Lists'),
                backgroundColor: kLightAccentColour,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                child: saveReady == false ? Icon(Icons.edit) : Icon(Icons.save),
                foregroundColor: kPrimaryTextColour,
                backgroundColor: kAccentColour,
                onPressed: () {
                  setState(() {
                    editOn = !editOn;
                    saveReady = !saveReady;
                    // Counter to check if the text is ready to be saved
                    counter++;
                    if (counter.isEven) {
                      editedText = _controller.value.text;
                      updateNote(snapshot.data['title'], editedText, noteID,
                          userData.family);
                    }
                  });
                },
              ),
              body: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: CenterHorizontal(
                      Text(
                        snapshot.data['title'],
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 15.0),
                        child: editOn == true
                            ? Container(
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration.collapsed(
                                    border: InputBorder.none,
                                    hintText: '',
                                  ),
                                  autofocus: true,
                                  maxLines: null,
                                ),
                              )
                            : Container(
                                child: Text(
                                  snapshot.data['body'],
                                  style: TextStyle(fontSize: 18.0),
                                  maxLines: null,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100.0),
                ],
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}

void updateNote(
    String title, String newText, String noteID, String? userFamily) {
  FirebaseFirestore.instance
      .collection('families')
      .doc(userFamily)
      .collection('docs')
      .doc(noteID)
      .update({'body': newText});
}
