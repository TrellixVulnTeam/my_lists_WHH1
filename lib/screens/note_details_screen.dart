import 'package:flutter/material.dart';
import 'package:my_lists/components/center_text.dart';
import 'package:my_lists/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/models/models.dart';
import 'package:provider/provider.dart';

final db = FirebaseFirestore.instance;
late User loggedInUser;
bool editOn = false;
bool saveReady = false;
late String editedText;

//ignore: must_be_immutable
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
  void initState() {
    editOn = false;
    saveReady = false;
    counter = 0;
    super.initState();
  }

  @override
  void dispose() {
    widget.noteBody = '';
    super.dispose();
  }

  TextEditingController _controller = TextEditingController();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    _controller.text = (widget.noteBody);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
        backgroundColor: kLightAccentColour,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              updateNote(
                  widget.noteTitle, editedText, widget.noteID, userData.family);
            }
          });
          final _newValue = widget.noteBody;
          _controller.value = TextEditingValue(
            text: _newValue,
            selection: TextSelection.fromPosition(
              TextPosition(offset: _newValue.length),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: CenterHorizontal(
                Text(
                  widget.noteTitle,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
              child: editOn == true
                  ? TextField(
                      controller: _controller,
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: '',
                      ),
                      autofocus: true,
                    )
                  : Text(
                      widget.noteBody,
                      style: TextStyle(fontSize: 18.0),
                    ),
            ),
          ],
        ),
      ),
    );
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
