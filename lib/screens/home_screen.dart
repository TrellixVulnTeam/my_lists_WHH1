import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/components/center_text.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/new_list.dart';
import 'package:my_lists/screens/edit_users_screen.dart';
import 'package:my_lists/screens/login_screen.dart';
import 'package:my_lists/screens/user_registration_screen.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/components/new_text.dart';
import 'package:my_lists/models/models.dart';
import 'package:provider/provider.dart';

final db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
final authUser = FirebaseAuth.instance.currentUser;
String docType = 'list';
bool onlyFav = false;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
          backgroundColor: kLightAccentColour,
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: kPrimaryTextColour,
              ),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: kSuperLightAccentColour,
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onlyFav == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (Text(
                      'Favourites only',
                      style: TextStyle(fontSize: 20.0, color: kAccentColour),
                    )),
                  ],
                ),
              Row(
                //children inside bottom appbar
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color:
                          onlyFav == true ? kAccentColour : kPrimaryTextColour,
                    ),
                    onPressed: () {
                      setState(() {
                        onlyFav = !onlyFav;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 90),
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.people,
                        color: kPrimaryTextColour,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('User Settings'),
                          value: 1,
                        ),
                        if (userData.isAdmin == true)
                          PopupMenuItem(
                            child: Text('Register New User'),
                            value: 2,
                          ),
                        if (userData.isAdmin == true)
                          PopupMenuItem(
                            child: Text('Edit Users'),
                            value: 3,
                          ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            print('You chose settings');
                            break;
                          case 2:
                            Navigator.pushNamed(
                                context, UserRegistrationScreen.id);
                            break;
                          case 3:
                            Navigator.pushNamed(context, EditUsers.id);
                            break;
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: InkWell(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: kSuperLightAccentColour,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          docType = 'list';
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NewList();
                            },
                          );
                        },
                        child: Text(
                          'New List',
                          style: TextStyle(
                              fontSize: 25, color: kPrimaryTextColour),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          docType = 'note';
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return NewText();
                            },
                          );
                        },
                        child: Text(
                          'New Note',
                          style: TextStyle(
                              fontSize: 25, color: kPrimaryTextColour),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: FloatingActionButton(
            child: Icon(Icons.add),
            foregroundColor: kPrimaryTextColour,
            backgroundColor: kAccentColour,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  if (docType == 'list') {
                    return NewList();
                  } else
                    return NewText();
                },
              );
            },
          ),
        ),
        body: Column(children: [
          Container(
            margin:
                EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: kAccentColour,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome, ${userData.firstName}!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0),
                ),
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: Text(
                'Here\'s the latest for the ${userData.family} family',
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          //
          Expanded(child: DocsList()),
        ]),
      ),
    );
  }
}
