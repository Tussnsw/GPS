import 'package:flutter/material.dart';
import 'package:helloworld/screen/Carlist.dart';
import 'package:helloworld/screen/LoginScreen.dart';
import 'package:helloworld/screen/MapScreen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginScreen(),
          '/map': (context) => MapsDemo(),
          '/carlist': (context) => Carlist(),
        }
    );
  }
}