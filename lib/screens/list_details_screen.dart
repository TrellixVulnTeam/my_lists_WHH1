import 'package:flutter/cupertino.dart';
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

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);
    final db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
        backgroundColor: kLightAccentColour,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: db
              .collection('families')
              .doc(user.family)
              .collection('docs')
              .doc(listID)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            // print(snapshot.data['body'].toString());
            print(snapshot.data['body']);
            if (snapshot.hasData) {
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
                    child: Text(''),
                    // child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: snapshot.data['body'].length,
                    //     itemBuilder: (context, int index) {
                    //       return ItemTile(
                    //           isDone: snapshot.data['body'][index].isDone,
                    //           name: listBot[index].name,
                    //           onTapped: () {
                    //             setState(() {
                    //               toggleDone(
                    //                   listBot[index].name,
                    //                   listID,
                    //                   (listBot[index].isDone =
                    //                       !listBot[index].isDone),
                    //                   user.family);
                    //             });
                    //           });
                    //     }),
                  )
                ],
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.only(top: 15.0),
      //       child: Text(
      //         listTitle,
      //         style: TextStyle(fontSize: 25.0),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(15.0),
      //       child: ListView.builder(
      //           shrinkWrap: true,
      //           itemCount: listBody.length,
      //           itemBuilder: (context, int index) {
      //             return ItemTile(
      //                 isDone: listBody[index].isDone,
      //                 name: listBody[index].name,
      //                 onTapped: () {
      //                   setState(() {
      //                     toggleDone(
      //                         listBody[index].name,
      //                         listID,
      //                         (listBody[index].isDone =
      //                             !listBody[index].isDone),
      //                         user.family);
      //                   });
      //                 });
      //           }),
      //     )
      //   ],
      // ),
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
