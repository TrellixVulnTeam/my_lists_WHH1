import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_lists/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_lists/screens/list_details_screen.dart';
import 'package:my_lists/models/item.dart';
import 'package:my_lists/screens/note_details_screen.dart';

final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
var listTitle;
late List listBody = [];
Map newMap = {};
late String name;
late bool isDone;
late String listID;
late String docText;
late String noteID;

class DocsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference docs =
        db.collection('users').doc(_auth.currentUser!.uid).collection('docs');

    return StreamBuilder<QuerySnapshot>(
        stream: docs.orderBy('created at', descending: true).snapshots(),
        builder: (homeScreenState, snapshot) {
          if (!snapshot.hasData) {
            return Text('No data');
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: StaggeredGridView.count(
              staggeredTiles: snapshot.data!.docs
                  .map<StaggeredTile>((_) => StaggeredTile.fit(1))
                  .toList(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                // Change display if note or list
                if (document['type'] == 'list') {
                  // Get a list from the map to be able to manipulate later
                  listBody = document['body']
                      .entries
                      .map((e) => SingleItem(name: e.key, isDone: e.value))
                      .toList();
                  // If doc is a note then just display
                } else if (document['type'] == 'note') {
                  docText = document['body'];
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: kLightAccentColour,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document['title'],
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 3),
                          // Limit the list to 5 items, iterate over to show each item and add '...' when bigger than 5
                          if (document['type'] == 'list')
                            for (var item in listBody.take(5))
                              Text(
                                item.name,
                                style: TextStyle(
                                  decoration: item.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                          if (document['type'] == 'list' && listBody.length > 5)
                            Text('...'),
                          if (document['type'] == 'note')
                            Text(
                              docText,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (document['type'] == 'list') {
                        listBody = document['body']
                            .entries
                            .map(
                                (e) => SingleItem(name: e.key, isDone: e.value))
                            .toList();
                        listTitle = document['title'];
                        listID = document.id;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListDetailsScreen(
                              listTitle: document['title'],
                              listBody: listBody,
                              listID: listID,
                            ),
                          ),
                        );
                      } else if (document['type'] == 'note') {
                        noteID = document.id;
                        docText = document['body'];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailsScreen(
                              noteTitle: document['title'],
                              noteBody: docText,
                              noteID: noteID,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}
