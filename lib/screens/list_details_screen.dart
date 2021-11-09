import 'package:flutter/material.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/item_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User loggedInUser;
var loggedInUserFamily = '';

class ListDetailsScreen extends StatefulWidget {
  final listTitle;
  final List listBody;
  final listID;

  ListDetailsScreen({this.listTitle, required this.listBody, this.listID});

  @override
  _ListDetailsScreenState createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  @override
  void initState() {
    getCurrentUserDetails();
    super.initState();
  }

  void getCurrentUserDetails() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      loggedInUser = currentUser;

      // Get the whole user doc and then process the snapshot to get to the fields
      Future<String> getDetails() async {
        DocumentReference userRef =
            db.collection('users').doc(loggedInUser.uid);
        String firstName = '';
        String family = '';
        await userRef.get().then((snapshot) {
          firstName = snapshot['firstName'];
          family = snapshot['family'];
          currentUserIsAdmin = snapshot['isAdmin'];
        });
        setState(() {
          loggedInUserFamily = family;
        });
        return firstName;
      }

      getDetails();
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
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: listBody.length,
                itemBuilder: (context, int index) {
                  return ItemTile(
                      isDone: listBody[index].isDone,
                      name: listBody[index].name,
                      onTapped: () {
                        setState(() {
                          toggleDone(
                              listBody[index].name,
                              listID,
                              (listBody[index].isDone =
                                  !listBody[index].isDone));
                        });
                      });
                }),
          )
        ],
      ),
    );
  }
}

void toggleDone(String itemName, String listID, bool isDone) {
  FirebaseFirestore.instance
      .collection('families')
      .doc(loggedInUserFamily)
      .collection('docs')
      .doc(listID)
      .update({'body.$itemName': isDone}).then((_) {});
}
