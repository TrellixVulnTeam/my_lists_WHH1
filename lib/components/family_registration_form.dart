import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/custom_button.dart';
import 'package:my_lists/screens/home_screen.dart';

bool isSuccessful = false;
final db = FirebaseFirestore.instance;

class FamilyRegistrationForm extends StatefulWidget {
  @override
  _FamilyRegistrationFormState createState() => _FamilyRegistrationFormState();
}

class _FamilyRegistrationFormState extends State<FamilyRegistrationForm> {
  final _familyRegistrationFormKey = GlobalKey<FormState>();

  late String _email;
  late String _password;
  late String _firstName;
  late String _familyName;
  bool _isAdmin = false;

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

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
      "family": _familyName,
    };

    String uid = "0";
    await createUserCallable(data)
        .then((response) async => {
              if (response.data['status'] == 'success')
                {
                  isSuccessful = true,
                  showAlertDialog(context, 'Family Created Successfully!'),
                  // Need the signIn event in order to get the Providers in main.dart working
                  await _auth.signInWithEmailAndPassword(
                      email: _email, password: _password),
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
    return Form(
      key: _familyRegistrationFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              textAlign: TextAlign.center,
              decoration:
                  kLoginTextFieldDecoration.copyWith(hintText: 'Family Name'),
              onChanged: (value) {
                _familyName = value.trim();
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name for your family.';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            Text(
              'Your User Details',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 25.0),
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
            SizedBox(height: 15.0),
            TextFormField(
              textAlign: TextAlign.center,
              decoration:
                  kLoginTextFieldDecoration.copyWith(hintText: 'Email Address'),
              onChanged: (value) {
                _email = value.trim();
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email address';
                }
                return null;
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            SizedBox(height: 25.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomButton(
                  text: 'Register New Family',
                  colour: kAccentColour,
                  radius: 32,
                  onPress: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (_familyRegistrationFormKey.currentState!.validate()) {
                      _isAdmin = true;
                      createUser();
                      addFamily(_familyName);

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
    );
  }
}

showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(isSuccessful == true ? message : 'Unable to Create Family'),
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

void addFamily(name) {
  DocumentReference families = db.collection('families').doc(name);

  Future<void> addingFamily() {
    return families
        .set({
          'familyName': name,
          'created_at': FieldValue.serverTimestamp(),
        })
        .then((value) => print("Family Added"))
        .catchError((error) => print("Failed to add family: $error"));
  }

  addingFamily();
}
