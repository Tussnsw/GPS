import 'package:flutter/material.dart';

class Carlist extends StatelessWidget {
  final List<String> items =
      List<String>.generate(5, (index) => "Car number: ${++index}");



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Car Lists",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Car Lists"),
        ),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text("${items[index]}"),
                    subtitle: Text("Select Your Cars"),
                    trailing: Icon(Icons.notifications_none),
                  ),
                  Divider(height: 2, color: Colors.grey.shade300,
                  )
                ],
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/map");
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
    );

  }
}
