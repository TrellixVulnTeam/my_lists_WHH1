import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/new_list.dart';
import 'package:my_lists/screens/login_screen.dart';
import 'package:my_lists/screens/user_registration_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
          backgroundColor: kLightAccentColour,
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // DrawerHeader wrapped with Container to change the height
              Container(
                height: 100.0,
                child: DrawerHeader(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColour,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Register New User',
                  style: TextStyle(color: kPrimaryTextColour),
                ),
                onTap: () {
                  Navigator.pushNamed(context, UserRegistrationScreen.id);
                },
              ),
              ListTile(
                title: Text(
                  'Edit Users',
                  style: TextStyle(color: kPrimaryTextColour),
                ),
                onTap: () {},
              ),

              ListTile(
                title: Text(
                  'Log Out',
                  style: TextStyle(color: kPrimaryTextColour),
                ),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: kPrimaryTextColour,
          backgroundColor: kAccentColour,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return NewList();
              },
            );
          },
        ),
        body: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: [],
        ),
      ),
    );
  }
}
