import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_setup/screens/login_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}
