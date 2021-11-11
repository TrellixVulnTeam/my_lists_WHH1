import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:my_lists/models/models.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final uid;
  final listID;

  DatabaseService({this.uid, this.listID});

  // User data details to be available to all widgets
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        email: snapshot['email'],
        firstName: snapshot['firstName'],
        family: snapshot['family'],
        isAdmin: snapshot['isAdmin']);
  }

  // Get user stream from Firestore
  Stream<UserData> get userData {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  // ListData _listDataFromSnapshot(DocumentSnapshot snapshot) {
  //   return ListData(
  //     listID: snapshot.id,
  //     listBody: snapshot['body'],
  //     listTitle: snapshot['title'],
  //   );
  // }
  //
  // // Get user stream from Firestore
  // Stream<ListData> get listData {
  //   return _db
  //       .collection('families')
  //       .doc(uid)
  //       .collection('docs')
  //       .doc(listID)
  //       .snapshots()
  //       .map(_listDataFromSnapshot);
  // }
}
