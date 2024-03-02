import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'Login',
      routes: {
        'Home': (context) => DashboardScreen(),
        'Login': (context) => MyLogin(),
        'Register': (context) => RegistrationPage(),
      },
    );
  }
}
