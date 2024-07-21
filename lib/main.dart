import 'package:flutter/material.dart';
import 'pages/my_trips_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journey Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyTripsPage(
          userId:
              '6671b214613f5493b0afe5ca'), // TEST USER ID, CONSULT CHRIS & OLGA FOR FUTURE IMPLEMENTATION
    );
  }
}
