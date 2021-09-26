import 'package:flutter/material.dart';
import 'package:my_lists/routes.dart';
import 'package:my_lists/theme/style.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme(),
      initialRoute: '/',
      routes: routes,
    );
  }
}

//TODO: Create family registration page - access from login screen
//TODO: First user in the family is admin
//TODO: Change form depending on which page you're coming from, pass specific form through navigation??
