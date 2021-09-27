import 'package:flutter/widgets.dart';
import 'package:my_lists/components/new_list.dart';
import 'package:my_lists/screens/home_screen.dart';
import 'package:my_lists/screens/login_screen.dart';
import 'package:my_lists/screens/user_registration_screen.dart';
import 'package:my_lists/screens/family_registration_screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (context) => LoginScreen(),
  HomeScreen.id: (context) => HomeScreen(),
  NewList.id: (context) => NewList(),
  LoginScreen.id: (context) => LoginScreen(),
  UserRegistrationScreen.id: (context) => UserRegistrationScreen(),
  FamilyRegistrationScreen.id: (context) => FamilyRegistrationScreen(),
};
