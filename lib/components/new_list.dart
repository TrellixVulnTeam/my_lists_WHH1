import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/list_field.dart';

final db = FirebaseFirestore.instance;

late User loggedInUser;
String? title;
late String item;
late FocusNode myFocus = FocusNode();

List<String> listItems = [];

class NewList extends StatefulWidget {
  static const String id = 'new_list';

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  final _auth = FirebaseAuth.instance;
  List<Widget> itemLines = [];
  List<TextEditingController> controllers = [];
  TextEditingController initialController = TextEditingController();
  late FocusNode dynamicFocus = FocusNode();

  @override
  void initState() {
    getCurrentUser();
    controllers.add(initialController);
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
    controllers.clear();
    dynamicFocus.dispose();
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
                controller: initialController,
                lineFocus: myFocus,
              ),
              ListView(
                shrinkWrap: true,
                children: itemLines,
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
                        listItems.clear();
                        itemLines.clear();
                        title = null;
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Create List',
                        style: TextStyle(
                            color: kPrimaryTextColour, fontSize: 25.0),
                      ),
                      onPressed: () {
                        // adding items to the list
                        for (int i = 0; i < controllers.length; i++) {
                          listItems = List.from(listItems)
                            ..add(controllers[i].text);
                        }
                        title == null ? title = 'Untitled' : title = title;
                        createList(title);
                        listItems.clear();
                        itemLines.clear();
                        title = null;
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

  void _addLine() {
    List<FocusNode> focusList = [];
    dynamicFocus = FocusNode();
    for (int i = 0; i < itemLines.length; i++) {
      focusList = List.from(focusList)..add(dynamicFocus);
    }
    dynamicFocus.requestFocus();

    TextEditingController controller = TextEditingController();
    controllers.add(controller); //adding the current controller to the list

    // .. notation is cascade operator, used to not repeat 'listItems'. This is equivalent to the next 2 lines commented out
    itemLines = List.from(itemLines)
      ..add(
        ListField(
          controller: controller,
          lineFocus: dynamicFocus,
        ),
      );
    //itemLines = List.from(itemLines);
    //itemLines.add(TextFormField(controller: controller));
    setState(() {});
  }
}

void createList(title) {
  CollectionReference lists =
      db.collection('users').doc(loggedInUser.uid).collection('lists');

  Future<void> creatingList() {
    return lists
        // use add instead of set to prevent overwriting
        .add({
          'title': title,
          'body': listItems,
          'created at': FieldValue.serverTimestamp(),
          'created by': loggedInUser.email,
        })
        .then((value) => print("List Added with title: $title"))
        .catchError((error) => print("Failed to add list: $error"));
  }

  creatingList();
}
