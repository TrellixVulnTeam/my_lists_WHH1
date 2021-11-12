import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/new_list.dart';
import 'dart:async';
import 'package:my_lists/models/models.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final uid;
  final listID;
  final userFamily;

  DatabaseService({this.uid, this.listID, this.userFamily});

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

  ListData _listDataFromSnapshot(DocumentSnapshot snapshot) {
    return ListData(
        listID: uid, listTitle: snapshot['email'], listBody: snapshot['body']);
  }

  // Get user stream from Firestore
  Stream<UserData> get listData {
    return _db
        .collection('families')
        .doc(userFamily)
        .collection('docs')
        .doc(listID)
        .snapshots()
        .map(_userDataFromSnapshot);
  }
}
