import 'package:flutter/material.dart';
import 'my_trips_page.dart';

void main() {
  runApp(MyTripsApp());
}

class MyTripsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journey Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyTripsPage(),
    );
  }
}
