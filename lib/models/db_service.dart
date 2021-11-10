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

  // DocumentData _documentDataFromSnapshot(QuerySnapshot snapshot) {
  //   var body;
  //   var title;
  //   var isPrivate;
  //   var docID;
  //   var type;
  //   snapshot.docs.forEach((DocumentSnapshot document) {
  //     body = document['body'];
  //     title = document['title'];
  //     isPrivate = document['isPrivate'];
  //     docID = document.id;
  //     type = document['type'];
  //   });
  //   return DocumentData(
  //     docBody: body,
  //     docID: docID,
  //     type: type,
  //     isPrivate: isPrivate,
  //     docTitle: title,
  //   );
  // }
  //
  // // Get documents stream from Firestore
  // Stream<DocumentData> get documentData {
  //   return _db
  //       .collection('families')
  //       .doc('Smed')
  //       .collection('docs')
  //       .snapshots()
  //       .map(_documentDataFromSnapshot);
  // }
}
