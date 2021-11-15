import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/item_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/models/item.dart';
import 'package:provider/provider.dart';
import 'package:my_lists/models/models.dart';

final db = FirebaseFirestore.instance;
late final isDone;
late final name;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
        backgroundColor: kLightAccentColour,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      snapshot.data['title'].toString(),
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listOfItems.length,
                        itemBuilder: (context, int index) {
                          return ItemTile(
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
                          );
                        }),
                  )
                ],
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
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
