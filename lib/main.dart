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
              'dummy_user_id'), // Replace with actual user ID after implementing authentication
    );
  }
}
