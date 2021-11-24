import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/screens/edit_users_screen.dart';
import '../components/custom_button.dart';
import 'package:my_lists/components/user_details_field.dart';

CollectionReference userRef = FirebaseFirestore.instance.collection('users');

enum Answers { Yes, No }

bool isSuccessful = false;

// ignore: must_be_immutable
class UserDetailsScreen extends StatelessWidget {
  static const String id = 'user_details_screen';

  late String firstName;
  final userID;
  late String userEmail;

  UserDetailsScreen({
    required this.firstName,
    this.userID,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> updateConfirm() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 24.0,
            title: Text('Update User'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Update User Details?',
                    style: TextStyle(color: kPrimaryTextColour),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  updateUser(userID, userEmail, firstName);
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

    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
        backgroundColor: kLightAccentColour,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: kLightAccentColour,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'User Details',
                  style: TextStyle(fontSize: 25, color: kPrimaryTextColour),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UserDetailsField(
                    label: 'First Name',
                    content: firstName,
                    onChange: (value) => firstName = value,
                  ),
                  UserDetailsField(
                    label: 'Email Address',
                    content: userEmail,
                    onChange: (value) => userEmail = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0),
                    child: CustomButton(
                      text: 'Update User Details',
                      colour: kLightAccentColour,
                      radius: 25.0,
                      onPress: () {
                        updateConfirm();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void updateUser(String userID, String userEmail, String firstName) {
  // Create doc to trigger function to change email in Auth
  Map<String, dynamic> data = {'uid': userID, 'email': userEmail};
  FirebaseFirestore.instance.collection('users_update_email').doc().set(data);

  // Update details in Firestore
  userRef.doc(userID).update({
    'firstName': firstName,
    'email': userEmail,
  });
}
