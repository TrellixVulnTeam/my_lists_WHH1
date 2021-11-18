import 'package:flutter/material.dart';
import 'package:my_lists/routes.dart';
import 'package:my_lists/screens/home_screen.dart';
import 'package:my_lists/screens/login_screen.dart';
import 'package:my_lists/theme/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/db_service.dart';
import 'models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

//The App() handles makes the providers globally accessible
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuthProviderLayer(
      child: AuthorizedProviderLayer(
        authorizedChild: MyApp(child: HomeScreen()),
        unAuthorizedChild: MyApp(child: LoginScreen()),
      ),
    );
  }
}

//The MaterialApp Wrapped so that it not has to be rewritten
class MyApp extends StatelessWidget {
  final Widget child;

  MyApp({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Lists',
      theme: appTheme(),
      routes: routes,
      home: child,
    );
  }
}

class FirebaseAuthProviderLayer extends StatelessWidget {
  final Widget child;

  FirebaseAuthProviderLayer({required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      child: child,
    );
  }
}

//And the layer that decides either or not we should attach all the providers that requires the user to be authorized.
//ignore: must_be_immutable
class AuthorizedProviderLayer extends StatelessWidget {
  final Widget authorizedChild;
  final Widget unAuthorizedChild;

  AuthorizedProviderLayer(
      {required this.unAuthorizedChild, required this.authorizedChild});

  late User? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User?>(context);
    if (user is User)
      return MultiProvider(
        providers: [
          StreamProvider<UserData>.value(
              value: DatabaseService(uid: user!.uid).userData,
              initialData: UserData.initialData()),
        ],
        child: authorizedChild,
      );
    return unAuthorizedChild;
  }
}

// TODO: bottom menu
// TODO: work out security on DB????
