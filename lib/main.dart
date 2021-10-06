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
// TODO: list details screen + tick off items
// TODO: bottom menu
// TODO: share lists within family
// TODO: private toggle
// TODO: different types of docs, not just lists
// TODO: more freeform GridView
