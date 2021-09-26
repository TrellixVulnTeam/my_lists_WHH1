import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_lists/screens/home_screen.dart';
import 'package:my_lists/components/center_text.dart';
import 'package:my_lists/constants.dart';
import 'package:my_lists/components/custom_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Image.asset('assets/images/logo-100.png'),
                ),
                CenterHorizontal(
                  Text(
                    'My Lists',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: kDarkAccentColour,
                      fontSize: 50,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  decoration:
                      kLoginTextFieldDecoration.copyWith(hintText: 'Username'),
                  onChanged: (value) {
                    email = value.trim();
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration:
                      kLoginTextFieldDecoration.copyWith(hintText: 'Password'),
                  onChanged: (value) {
                    password = value.trim();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      text: 'Log In',
                      colour: kAccentColour,
                      radius: 32,
                      onPress: () async {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(
                              context,
                              HomeScreen.id,
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
