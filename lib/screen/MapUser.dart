import 'dart:async';
// import 'Global.dart'as global;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

// import 'LoginScreen.dart';

class MapsDemo extends StatefulWidget {
  String plate="none";
  MapsDemo({this.plate});
  @override
  _MapsDemoState createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {
  // LoginScreen loginScreen = new LoginScreen();
  late Position userLocation;
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    userLocation = await Geolocator.getCurrentPosition();
    return userLocation;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference location = FirebaseFirestore.instance.collection("location");
    return Scaffold(
        body:FutureBuilder(
        future: _getLocation(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      location.doc(widget.plate).set({"latitude": userLocation.latitude, "longitude" : userLocation.longitude}).then((value) => null );
      print (widget.plate);
    return GoogleMap(
    mapType: MapType.normal,
    onMapCreated: _onMapCreated,
    myLocationEnabled: true,
    initialCameraPosition: CameraPosition(
    target: LatLng(userLocation.latitude, userLocation.longitude),
    zoom: 15),
    );
    } else {
    return Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    CircularProgressIndicator(),
    ],
    ),
    );
    }
    },
        ),
        bottomNavigationBar: BottomNavigationBar(
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.
        car_rental), label: 'car list'),
    BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'logout')
    ],
    onTap: (int index) async {
      if (index == 1) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: const Text('Logout'),
                content: const Text('Confirm to logout'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'OK');
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
        );
      }
      if (index == 0) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: const Text('List car'),
                content: const Text('You are not Admin'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
        );
      }
    },
    ),
    );
    }
    }

