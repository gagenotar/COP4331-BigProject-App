import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

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
        scaffoldBackgroundColor: Colors.yellow[50],
        primarySwatch: Colors.blue,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
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

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              height:200,
              width:200,
              //color: Colors.white,
              child: Image.asset(
                'assets/images/logo.png', 
                fit: BoxFit.scaleDown,
              )
            ),
          ),
          Container(
            //color:Colors.white,
            width: 400,
            child: Text(
              'JOURNEY JOURNAL',
              style:GoogleFonts.anton(
                color: Colors.black,
                fontSize:40
              ),
              
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip
            )
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical:10, horizontal:50),
            child: Text(
              'Enter your email to login.',
              style:TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:10, horizontal:50),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal:50),
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:0, horizontal:50),
            child: Container(
              alignment: AlignmentDirectional.centerEnd,
              width: double.infinity,
              child: TextButton(
                onPressed: () {}, 
                child: const Text(
                  'Forgot Password',
                  style:TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight:FontWeight.bold
                  )
                )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal:50),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton(
                onPressed: () {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                    
                  // Perform login logic here
                  if (email.isNotEmpty && password.isNotEmpty) {
                    // login logic
                  } 
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter email and password')),
                    );
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                      fontSize: 18,
                  )
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:0, horizontal:50),
            child: Container(
              alignment: AlignmentDirectional.center,
              width: double.infinity,
              child: TextButton(
                onPressed: () {}, 
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account? ",
                    style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight:FontWeight.bold
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign Up.",
                        style:TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight:FontWeight.bold
                        )
                      )
                    ]
                  )
                )
              )
            )
          )
        ]
      )
    );
  }
}