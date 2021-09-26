import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/user_registration_form.dart';

final db = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Safe Farm'),
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
                    'Register New User',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Expanded(
              child: SingleChildScrollView(
                child: UserRegistrationForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
