import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_lists/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_lists/components/user_registration_form.dart';

final db = FirebaseFirestore.instance;

class UserRegistrationScreen extends StatefulWidget {
  static const String id = 'user_registration_screen';

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final String currentFamily = arg['currentUserFamily'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: kPrimaryColour,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register new user for the',
                        style: TextStyle(fontSize: 25),
                      ),
                      if (currentFamily.length <= 19)
                        Text(
                          '$currentFamily family',
                          style: TextStyle(fontSize: 25),
                        ),
                      if (currentFamily.length > 19)
                        Text(
                          '$currentFamily',
                          style: TextStyle(fontSize: 25),
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (currentFamily.length > 19)
                        Text(
                          'family',
                          style: TextStyle(fontSize: 25),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            UserRegistrationForm(),
          ],
        ),
      ),
    );
  }
}
