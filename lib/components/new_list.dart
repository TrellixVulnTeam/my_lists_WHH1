import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/list_field.dart';
import 'package:my_lists/models/item.dart';
import 'package:provider/provider.dart';
import 'package:my_lists/models/models.dart';

final db = FirebaseFirestore.instance;

String? title;
bool isPrivate = false;
late String item;
late FocusNode myFocus = FocusNode();
var userFamily;
var userEmail;

List<SingleItem> listItems = [];
var mapItems = {};

class NewList extends StatefulWidget {
  static const String id = 'new_list';

  @override
  _NewListState createState() => _NewListState();
}

class _NewListState extends State<NewList> {
  List<Widget> itemLines = [];
  List<TextEditingController> controllers = [];
  TextEditingController initialController = TextEditingController();
  late FocusNode dynamicFocus = FocusNode();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    controllers.add(initialController);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controllers.clear();
    listItems.clear();
    mapItems.clear();
    dynamicFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Card(
            color: kLightAccentColour,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: itemLines,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _addLine();
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        setState(() {});
                      },
                      child: Icon(
                        Icons.add,
                        color: kPrimaryTextColour,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Private List',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Checkbox(
                        value: isPrivate,
                        onChanged: (value) {
                          setState(() {
                            isPrivate = value!;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: kPrimaryTextColour, fontSize: 20.0),
                      ),
                      onPressed: () {
                        listItems.clear();
                        itemLines.clear();
                        title = null;
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: TextButton(
                        child: Text(
                          'Create List',
                          style: TextStyle(
                              color: kPrimaryTextColour, fontSize: 20.0),
                        ),
                        onPressed: () {
                          for (int i = 0; i < controllers.length; i++) {
                            SingleItem currentItem = SingleItem(
                                name: controllers[i].text, isDone: false);

                            listItems = List.from(listItems)..add(currentItem);

                            listItems.forEach(
                              (item) {
                                mapItems[item.name] = item.isDone;
                              },
                            );
                          }
                          title == null ? title = 'Untitled' : title = title;
                          userFamily = userData.family;
                          userEmail = userData.email;
                          createList(title);
                          listItems.clear();
                          itemLines.clear();
                          title = null;
                          Navigator.of(context).pop();
                        },
                      ),
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
  DocumentReference docs =
      db.collection('families').doc(userFamily).collection('docs').doc();

  Future<void> creatingList() async {
    // Create the new document with autogenerated ID
    var tempNewDoc = docs;

    // Use ID created above to set the data in the document
    var newDoc = await docs
        .set({
          'title': title,
          'body': mapItems,
          'created_at': FieldValue.serverTimestamp(),
          'created_by': userEmail,
          'type': 'list',
          'isPrivate': isPrivate,
          'id': tempNewDoc.id,
          'isFav': false,
        })
        .then((value) => print("List Added with title: $title"))
        .catchError((error) => print("Failed to add list: $error"));

    return newDoc;
  }

  creatingList();
}
