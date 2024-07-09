import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:journey_journal_app/homePage.dart';
import 'package:journey_journal_app/register_page.dart';

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
            child: SizedBox(
              height:200,
              width:200,
              child: Image.asset(
                'assets/images/logo.png', 
                fit: BoxFit.scaleDown,
              )
            ),
          ),
          SizedBox(
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

          LREntryBox(
            textController: _emailController, 
            label: 'Email Address',
            keyboard: 'email'
          ),

          LREntryBox(
            textController: _passwordController, 
            label: 'Password',
            keyboard: 'password',
            isPassword: true
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
                    // for debug purposes, it is routing to the home page with any input in email and password
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
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


          // Don't have an account? Sign up.
          Padding(
            padding: const EdgeInsets.symmetric(vertical:0, horizontal:50),
            child: Container(
              alignment: AlignmentDirectional.center,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                }, 
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

class LREntryBox extends StatelessWidget {

  const LREntryBox({
    super.key,
    required this.textController,
    required this.label,
    this.keyboard = 'text',
    this.isPassword = false
  });

  static final fieldType = {
    'email': TextInputType.emailAddress,
    'name': TextInputType.name,
    'password': TextInputType.visiblePassword,
    'text': TextInputType.text,
  };

  final TextEditingController textController;
  final String label;

  final String keyboard;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10, horizontal:50),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: fieldType[keyboard],
        obscureText: isPassword
      ),
    );
  }
}