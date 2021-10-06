import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_lists/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class DocsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference lists =
        db.collection('users').doc(_auth.currentUser!.uid).collection('lists');

    return StreamBuilder<QuerySnapshot>(
        stream: lists.orderBy('created at').snapshots(),
        builder: (homeScreenState, snapshot) {
          if (!snapshot.hasData) {
            return Text('No data');
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
                          ),
                          for (int i = 0; i < document['body'].length; i++)
                            Text(document['body'][i])
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}
