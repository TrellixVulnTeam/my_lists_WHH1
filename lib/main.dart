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
      title: 'My Lists',
      theme: appTheme(),
      initialRoute: '/',
      routes: routes,
    );
  }
}

// TODO: bottom menu
// TODO: amend lists or note after creation
// TODO: work out security on DB????
// TODO: refactor getUserDetails
