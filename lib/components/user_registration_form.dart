import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/custom_button.dart';
import 'package:my_lists/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isSuccessful = false;
final db = FirebaseFirestore.instance;

class UserRegistrationForm extends StatefulWidget {
  @override
  _UserRegistrationFormState createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _userRegistrationFormKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  bool currentUserIsAdmin = false;
  late String _currentUserFamily;

  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    getCurrentUserFamily();
    super.initState();
  }

  void getCurrentUserFamily() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      loggedInUser = currentUser;

      // Get the whole user doc and then process the snapshot to get to the fields
      Future<String> getDetails() async {
        DocumentReference userRef =
            db.collection('users').doc(loggedInUser.uid);
        String family = '';
        await userRef.get().then((snapshot) {
          if (snapshot.data() != null) {
            family = snapshot['family'];
            currentUserIsAdmin = snapshot['isAdmin'];
          }
        });
        setState(() {
          _currentUserFamily = family;
        });
        return family;
      }

      getDetails();
    }
  }

  late String _email;
  late String _password;
  late String _firstName;
  bool _isAdmin = false;

  bool showSpinner = false;

  // define callable function
  HttpsCallable createUserCallable = FirebaseFunctions.instance.httpsCallable(
      'createUser',
      options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

  Future<String> createUser() async {
    //create the data map to be send
    Map<String, dynamic> data = {
      "email": _email,
      "password": _password,
      "firstName": _firstName,
      "isAdmin": _isAdmin,
      "family": _currentUserFamily,
    };

    String uid = "0";
    await createUserCallable(data)
        .then((response) => {
              if (response.data['status'] == 'success')
                {
                  isSuccessful = true,
                  showAlertDialog(context, 'User Created Successfully!'),
                }
              else
                {
                  isSuccessful = false,
                  showAlertDialog(context, response.data['message']),
                }
            })
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((err) => {print(err.toString())});

    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Form(
        key: _userRegistrationFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                decoration: kLoginTextFieldDecoration.copyWith(
                    hintText: 'Email Address'),
                onChanged: (value) {
                  _email = value.trim();
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                decoration:
                    kLoginTextFieldDecoration.copyWith(hintText: 'Password'),
                onChanged: (value) {
                  _password = value.trim();
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                textAlign: TextAlign.center,
                decoration:
                    kLoginTextFieldDecoration.copyWith(hintText: 'First Name'),
                onChanged: (value) {
                  _firstName = value.trim();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a first name.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              CheckboxListTile(
                  title: Text(
                    'Admin User',
                    style: TextStyle(color: kPrimaryTextColour),
                  ),
                  value: _isAdmin,
                  onChanged: (value) {
                    setState(() {
                      _isAdmin = value!;
                    });
                  }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    text: 'Register New User',
                    colour: kAccentColour,
                    radius: 32,
                    onPress: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      if (_userRegistrationFormKey.currentState!.validate()) {
                        createUser();

                        setState(() {
                          showSpinner = false;
                        });
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: Text('OK'),
    onPressed: () {
      isSuccessful == true
          ? Navigator.popAndPushNamed(context, HomeScreen.id)
          : Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title:
        Text(isSuccessful == true ? 'User Created' : 'Unable to Create User'),
    content: Text(
      message,
      style: TextStyle(color: kSecondaryTextColour),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
