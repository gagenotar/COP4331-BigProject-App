import 'package:flutter/material.dart';

import 'package:journey_journal_app/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.yellow.shade50,
        primarySwatch: Colors.blue,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow.shade50,
          brightness: Brightness.light,
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.blue
          )
        )
      ),

      home: LoginPage(),

    );
  }
}
