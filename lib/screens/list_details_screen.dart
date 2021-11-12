import 'package:flutter/material.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/components/new_list.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/item_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/models/item.dart';
import 'package:provider/provider.dart';
import 'package:my_lists/models/models.dart';
import 'package:my_lists/models/db_service.dart';

final db = FirebaseFirestore.instance;
late final isDone;
late final name;
List listBot = [];

class ListDetailsScreen extends StatefulWidget {
  final listID;

  ListDetailsScreen({this.listID});

  @override
  _ListDetailsScreenState createState() => _ListDetailsScreenState();
}

List<SingleItem> getListItems() {
  List<SingleItem> items = [];

  DocumentReference listRef =
      db.collection('families').doc(userFamily).collection('docs').doc(listID);

  listRef.get().then((document) {
    Map data = (document.data() as Map);
    data.forEach((key, value) {
      print('adding entry');
      items.add(SingleItem(
        isDone: value['isDone'],
        name: value['name'],
      ));
    });
  });

  return items;
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    var items = getListItems();
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
              'Booya',
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, int index) {
                  return ItemTile(
                      isDone: items[index].isDone,
                      name: items[index].name,
                      onTapped: () {
                        setState(() {
                          toggleDone(
                              items[index].name,
                              listID,
                              (items[index].isDone = !items[index].isDone),
                              user.family);
                        });
                      });
                }),
          )
        ],
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

// Future<void> toggleDone(
//   String listID,
//   String? userFamily,
//   String itemName,
//   bool isDone,
// ) async {
//   CollectionReference docs =
//       db.collection('families').doc(userFamily).collection('docs');
//
//   docs.get().then(
//         (QuerySnapshot snapshot) => {
//           snapshot.docs.forEach((d) {
//             var dID = d.reference;
//             print('List ID found: $listID');
//             //new
//             FirebaseFirestore.instance
//                 .runTransaction((transaction) async {
//                   // Get the document
//                   DocumentSnapshot snapshot = await transaction.get(dID);
//                   if (!snapshot.exists) {
//                     throw Exception("User does not exist!");
//                   }
//                   bool temp = false;
//                   print('it was $temp');
//                   temp = !temp;
//                   print('now its $temp');
//                   transaction.update(dID, {'body.$itemName': isDone = temp});
//
//                   // Return the new count
//                   //return temp;
//                 })
//                 .then((value) => print("data updated"))
//                 .catchError((error) => print("Failed to update : $error"));
//             //new done
//           }),
//         },
//       );
// }
