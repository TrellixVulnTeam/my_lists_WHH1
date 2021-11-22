import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/components/list_field.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/item_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/models/item.dart';
import 'package:provider/provider.dart';
import 'package:my_lists/models/models.dart';

final db = FirebaseFirestore.instance;
late String itemName;
TextEditingController controller = TextEditingController();

class ListDetailsScreen extends StatefulWidget {
  final listID;

  ListDetailsScreen({this.listID});

  @override
  _ListDetailsScreenState createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    final db = FirebaseFirestore.instance;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
          backgroundColor: kLightAccentColour,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: kPrimaryTextColour,
          backgroundColor: kAccentColour,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: AlertDialog(
                      title: Text('Add Item'),
                      backgroundColor: kSuperLightAccentColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      content: ListField(controller: controller),
                      actions: [
                        TextButton(
                          onPressed: () {
                            itemName = controller.text;
                            addItem(itemName, listID, userData.family);
                            controller.clear();
                            itemName = '';
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Add Item',
                            style: TextStyle(
                                fontSize: 20, color: kPrimaryTextColour),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.clear();
                            itemName = '';
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 20, color: kPrimaryTextColour),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: db
                .collection('families')
                .doc(userData.family)
                .collection('docs')
                .doc(listID)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // We got map from Firestore, make it into a List again to be able to use it in ListView below
                List listOfItems = snapshot.data['body'].entries
                    .map((e) => SingleItem(name: e.key, isDone: e.value))
                    .toList();
                return Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        snapshot.data['title'].toString(),
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0, bottom: 100.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listOfItems.length,
                            itemBuilder: (context, int index) {
                              return InkWell(
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Delete Item?'),
                                          backgroundColor:
                                              kSuperLightAccentColour,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  deleteItem(
                                                      listOfItems[index].name,
                                                      listID,
                                                      userData.family);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color:
                                                          kPrimaryTextColour),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color:
                                                          kPrimaryTextColour),
                                                ))
                                          ],
                                        );
                                      });
                                },
                                child: ItemTile(
                                  isDone: listOfItems[index].isDone,
                                  name: listOfItems[index].name,
                                  onTapped: () {
                                    setState(() {
                                      toggleDone(
                                          listOfItems[index].name,
                                          listID,
                                          (listOfItems[index].isDone =
                                              !listOfItems[index].isDone),
                                          userData.family);
                                    });
                                  },
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                );
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
      ),
    );
  }
}

void toggleDone(
    String itemName, String listID, bool isDone, String? userFamily) {
  FirebaseFirestore.instance
      .collection('families')
      .doc(userFamily)
      .collection('docs')
      .doc(listID)
      .update({'body.$itemName': isDone})
      .then((value) => print("data updated for item $itemName in list $listID"))
      .catchError((error) => print("Failed to update : $error"));
}

void deleteItem(String itemName, String listID, String? userFamily) {
  FirebaseFirestore.instance
      .collection('families')
      .doc(userFamily)
      .collection('docs')
      .doc(listID)
      .update({'body.$itemName': FieldValue.delete()});
}

void addItem(String itemName, String listID, String? userFamily) {
  FirebaseFirestore.instance
      .collection('families')
      .doc(userFamily)
      .collection('docs')
      .doc(listID)
      .update({'body.$itemName': false});
}
