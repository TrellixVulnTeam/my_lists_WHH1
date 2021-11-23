import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/custom_button.dart';
import 'package:my_lists/screens/edit_users_screen.dart';
import 'package:my_lists/screens/home_screen.dart';

bool isSuccessful = false;
final db = FirebaseFirestore.instance;
enum Answers { Yes, No }

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
  bool deleteSuccessful = false;
  bool isSuccessful = false;

  HttpsCallable deleteUserCallable = FirebaseFunctions.instance.httpsCallable(
      'deleteUserAuth',
      options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

  Future<void> deleteUser() async {
    // Create data map to be sent to the function
    Map<String, dynamic> data = {'uid': widget.userID};

    await deleteUserCallable(data)
        .then((response) => {
              if (response.data['status'] == 'success')
                {
                  deleteSuccessful = true,
                  showAlertDialog(context, 'User Deleted'),
                }
              else
                {
                  deleteSuccessful = false,
                  showAlertDialog(context, response.data['message']),
                }
            })
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((err) => {print(err.toString())});
  }

  Future<void> deleteUserDoc(String userID) async {
    FirebaseFirestore.instance.collection('users').doc(userID).delete();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => {showAlertDialog(context, 'Email sent')})
        .catchError((err) => {print(err.toString())});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> deleteConfirm() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 24.0,
            title: Text('Delete ${widget.userName}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Do you wish to delete this user?\nThis cannot be undone.',
                    style: TextStyle(color: kPrimaryTextColour),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  deleteUser();
                  deleteUserDoc(widget.userID);
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

    Future<void> updateConfirm() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
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

showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(isSuccessful == true ? message : 'Unable to Delete User'),
        content: Text(
          message,
          style: TextStyle(color: kSecondaryTextColour),
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () async {
              isSuccessful == true
                  ? Navigator.popAndPushNamed(context, HomeScreen.id)
                  : Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
