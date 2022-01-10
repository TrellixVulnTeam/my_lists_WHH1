import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/custom_button.dart';
import 'package:my_lists/models/models.dart';
import 'package:my_lists/screens/edit_users_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_lists/components/dialog.dart';

bool deleteDocs = false;
final db = FirebaseFirestore.instance;
enum Answers { Yes, No }
bool deleteSuccessful = false;

class UserSecurity extends StatefulWidget {
  final String userID;
  final String userEmail;
  final String userName;

  UserSecurity(
      {required this.userID, required this.userEmail, required this.userName});

  @override
  _UserSecurityState createState() => _UserSecurityState();
}

class _UserSecurityState extends State<UserSecurity> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    Future<void> deleteUserDocuments(String userID) {
      return FirebaseFirestore.instance
          .collection('families')
          .doc(userData.family)
          .collection('docs')
          .where('created_by', isEqualTo: widget.userEmail)
          .get()
          .then((value) {
        value.docs.forEach((document) {
          FirebaseFirestore.instance
              .collection('families')
              .doc(userData.family)
              .collection('docs')
              .doc(document.id)
              .delete()
              .then((value) => print('Deleted Successfully'))
              .catchError((error) => print('Error: $error'));
        });
      });
    }

    Future<void> deleteConfirm() {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 24.0,
            title: Text('Delete ${widget.userName}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Do you wish to delete this user?\nThis cannot be undone.',
                    style: TextStyle(color: kPrimaryTextColour),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return CheckboxListTile(
                      title: Text(
                        'Also delete all of ${widget.userName}\'s documents',
                        style: TextStyle(color: kPrimaryTextColour),
                      ),
                      value: deleteDocs,
                      onChanged: (value) {
                        setState(() {
                          deleteDocs = value!;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  deleteUser(widget.userID);
                  deleteUserDoc(widget.userID);
                  if (deleteDocs == true) deleteUserDocuments(widget.userID);
                  Navigator.popUntil(
                      context, ModalRoute.withName(EditUsers.id));
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> updateConfirm() {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 24.0,
            title: Text('Password Reset'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Send Password Reset Email?',
                    style: TextStyle(color: kPrimaryTextColour),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  resetPassword(widget.userEmail);
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
          backgroundColor: kLightAccentColour,
        ),
        body: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  child: Text(
                    widget.userName,
                    style: TextStyle(fontSize: 30.0, color: kPrimaryTextColour),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: CustomButton(
                    text: 'Send Reset Password Email',
                    colour: kSuperLightAccentColour,
                    radius: 25.0,
                    onPress: () {
                      updateConfirm();
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
                  child: CustomButton(
                    text: 'Delete User',
                    colour: Colors.red,
                    radius: 25.0,
                    onPress: () {
                      deleteDocs = false;
                      deleteConfirm();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

HttpsCallable deleteUserCallable = FirebaseFunctions.instance.httpsCallable(
    'deleteUserAuth',
    options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

Future<void> deleteUser(String userID) async {
  // Create data map to be sent to the function
  Map<String, dynamic> data = {'uid': userID};
  await deleteUserCallable(data).then((response) => {
        if (response.data['status'] == 'success')
          {
            deleteSuccessful = true,
            showCustomDialog('User Deleted'),
          }
        else
          {
            deleteSuccessful = false,
            showCustomDialog('Unable to delete user'),
          }
      });
}

Future<void> deleteUserDoc(String userID) async {
  FirebaseFirestore.instance.collection('users').doc(userID).delete();
}

Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance
      .sendPasswordResetEmail(email: email)
      .then((value) => {print('email sent')})
      .catchError((err) => {print(err.toString())});
}

// showAlertDialog(BuildContext context, String message) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//               deleteSuccessful == true ? message : 'Unable to Delete User'),
//           content: Text(
//             message,
//             style: TextStyle(color: kPrimaryTextColour),
//           ),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () async {
//                 deleteSuccessful == true
//                     ? Navigator.popAndPushNamed(context, HomeScreen.id)
//                     : Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       });
// }
