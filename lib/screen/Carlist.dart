import 'package:flutter/material.dart';

class CarDemo extends StatefulWidget {
  @override
  _CarState createState() => _CarState();
}

class _CarState extends State<CarDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Car Lists'),
    backgroundColor: Color(0xFF00796B),
    ),
    body: Stack(children: <Widget>[
    Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
    Color(0xFFE8F5E9),
    Color(0xFFA9EBEE),
    Color(0xFF7DDBC9),
    Color(0xFF51E3D8),
    Color(0xFF0AE3F8),
    ])),
    ),
    ]
    ),
    );
  }
}
