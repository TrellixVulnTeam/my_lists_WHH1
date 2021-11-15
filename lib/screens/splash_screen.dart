import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_lists/screens/home_screen.dart';
import 'package:my_lists/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String id = 'splash_screen';

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    bool loggedIn = user != null;
    if (loggedIn) {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, HomeScreen.id);
      });
      return Container();
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, LoginScreen.id);
      });

      return Container();
    }
  }
}
