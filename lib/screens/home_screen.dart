import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/new_list.dart';
import 'package:my_lists/screens/login_screen.dart';
import 'package:my_lists/screens/user_registration_screen.dart';
import 'package:my_lists/components/docs_list.dart';
import 'package:my_lists/components/new_text.dart';

final db = FirebaseFirestore.instance;
String docType = 'list';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User loggedInUser;
  String loggedInUserName = '';
  late bool currentUserIsAdmin;
  String loggedInUserFamily = '';

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUserDetails();
    super.initState();
  }

  void getCurrentUserDetails() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      loggedInUser = currentUser;

      // Get the whole user doc and then process the snapshot to get to the fields
      Future<String> getDetails() async {
        DocumentReference userRef =
            db.collection('users').doc(loggedInUser.uid);
        String firstName = '';
        String family = '';
        await userRef.get().then((snapshot) {
          firstName = snapshot['firstName'];
          family = snapshot['family'];
          currentUserIsAdmin = snapshot['isAdmin'];
        });
        setState(() {
          loggedInUserName = firstName;
          loggedInUserFamily = family;
        });
        return firstName;
      }

      getDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
          backgroundColor: kLightAccentColour,
        ),
        bottomNavigationBar: BottomAppBar(
          color: kSuperLightAccentColour,
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
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
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.only(right: 90),
                child: IconButton(
                  icon: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
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
                  Navigator.pushNamed(context, UserRegistrationScreen.id,
                      arguments: {'currentUserFamily': loggedInUserFamily});
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
                  'Welcome, $loggedInUserName!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              'Here\'s the latest for the $loggedInUserFamily family',
              style: TextStyle(fontSize: 25.0),
              textAlign: TextAlign.center,
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
