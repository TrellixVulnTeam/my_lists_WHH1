import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_lists/components/family_registration_form.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/user_registration_form.dart';

final db = FirebaseFirestore.instance;

class FamilyRegistrationScreen extends StatefulWidget {
  static const String id = 'family_registration_screen';

  @override
  _FamilyRegistrationScreenState createState() =>
      _FamilyRegistrationScreenState();
}

class _FamilyRegistrationScreenState extends State<FamilyRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: kPrimaryColour,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register New Family',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: SingleChildScrollView(
                child: FamilyRegistrationForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
