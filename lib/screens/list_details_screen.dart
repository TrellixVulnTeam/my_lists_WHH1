import 'package:flutter/material.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/item_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User loggedInUser;

class ListDetailsScreen extends StatefulWidget {
  final listTitle;
  final List listBody;

  ListDetailsScreen({this.listTitle, required this.listBody});

  @override
  _ListDetailsScreenState createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
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
    listBody.clear();
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
              listTitle,
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            // child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: listBody.length,
            //     itemBuilder: (context, int index) {
            //       return ItemTile(
            //           isDone: listBody[index].isDone,
            //           name: listBody[index].name,
            //           onTapped: () {
            //             listBody[index].isDone = !listBody[index].isDone;
            //             setState(() {});
            //           });
            //     }),
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var item in listBody)
                  ItemTile(
                    isDone: item.isDone,
                    name: item.name,
                    onTapped: () {
                      toggleDone(
                          item.name, listTitle, (item.isDone = !item.isDone));
                      setState(() {});
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void toggleDone(String itemName, String listTitle, bool isDone) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(loggedInUser.uid)
      .collection('lists')
      .doc(listTitle)
      .update({'body.$itemName.isDone': isDone}).then((_) {});
}
