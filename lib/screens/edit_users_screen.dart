import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/models/models.dart';
import 'package:my_lists/screens/user_details_screen.dart';
import 'package:my_lists/screens/user_security.dart';
import 'package:provider/provider.dart';

class EditUsers extends StatelessWidget {
  static const String id = 'edit_users';

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Lists'),
          backgroundColor: kLightAccentColour,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: kAccentColour,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 60,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          'Users for the',
                          style: TextStyle(fontSize: 30),
                        ),
                        if (userData.family!.length <= 23)
                          Text(
                            '${userData.family} family',
                            style: TextStyle(fontSize: 30),
                          ),
                        if (userData.family!.length > 23)
                          Text(
                            '${userData.family}',
                            style: TextStyle(fontSize: 30),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (userData.family!.length > 23)
                          Text(
                            'family',
                            style: TextStyle(fontSize: 30),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                flex: 4,
                child: UserList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    CollectionReference userList =
        FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
      stream: userList
          .where('family', isEqualTo: userData.family)
          .orderBy('firstName')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('No data');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          child: ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Container(
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: kAccentColour, width: 1.0),
                    borderRadius: BorderRadius.circular(15.0)),
                child: ListTile(
                  title: Text(
                    document['firstName'],
                    style: TextStyle(fontSize: 25.0),
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: kPrimaryTextColour,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetailsScreen(
                                        userID: document['uid'],
                                        userEmail: document['email'],
                                        firstName: document['firstName'],
                                      )));
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.security,
                          color: kPrimaryTextColour,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserSecurity(
                                        userID: document['uid'],
                                        userEmail: document['email'],
                                        userName: document['firstName'],
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
