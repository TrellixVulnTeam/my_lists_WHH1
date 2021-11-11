import 'package:flutter/material.dart';
import 'package:my_lists/routes.dart';
import 'package:my_lists/theme/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_lists/models/db_service.dart';
import 'package:my_lists/models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check for User to be able to use it in the StreamProvider below
    final _auth = FirebaseAuth.instance;
    final authUser = _auth.currentUser;
    if (authUser == null) {
      return MaterialApp(
        title: 'My Lists',
        theme: appTheme(),
        initialRoute: 'Login',
        routes: routes,
      );
    }
    return MultiProvider(
        providers: [
          // Get UserData to be able to use it everywhere
          StreamProvider<UserData>.value(
              initialData: UserData.initialData(),
              value: DatabaseService(uid: authUser.uid).userData),
          // StreamProvider<ListData>.value(
          //     initialData: ListData.initialData(),
          //     value: DatabaseService(uid: authUser.uid).listData),
        ],
        child: MaterialApp(
          title: 'My Lists',
          theme: appTheme(),
          initialRoute: '/',
          routes: routes,
        ));
  }
}

// TODO: bottom menu
// TODO: amend lists or note after creation
// TODO: work out security on DB????
