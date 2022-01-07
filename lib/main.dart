import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task1_rootly/screens/login_page.dart';
import 'package:task1_rootly/screens/pain_screen.dart';
import 'package:task1_rootly/screens/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) =>  LoginPage(),
        PainScreen.id: (context) =>  PainScreen(),
        RegistrationPage.id: (context) =>  RegistrationPage(),
      },
    );
  }
}
