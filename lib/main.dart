import 'package:flutter/material.dart';
import 'package:helloworld/screen/Carlist.dart';
import 'package:helloworld/screen/LoginScreen.dart' as global;
import 'package:helloworld/screen/MapUser.dart';
import 'package:helloworld/screen/car1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: global.LoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => global.LoginScreen(),
          '/map': (context) => MapsDemo(plate: 'none',),
          '/carlist': (context) => CarDemo(),
          '/admincar' : (context) => admincar(),
        }
    );
  }
}