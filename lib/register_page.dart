import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:journey_journal_app/homePage.dart';
import 'package:journey_journal_app/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      //resizeToAvoidBottomInset: false,
      body: ListView(
        children: <Widget>[

          const Flexible(
            child: SizedBox(
              height:50
            )
          ),

          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    height:160,
                    width:160,
                    child: Image.asset(
                      'assets/images/logo.png', 
                      fit: BoxFit.scaleDown,
                    )
                  ),
                ),
                SizedBox(
                  width: 200,
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
              ],
            ),
          ),
         
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical:10, horizontal:50),
            child: Text(
              'Sign up to post your adventures and share with friends.',
              style:TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),

          LREntryBox(
            textController: _firstNameController, 
            label: 'First Name',
            keyboard: 'name'
          ),

          LREntryBox(
            textController: _lastNameController, 
            label: 'Last Name',
            keyboard: 'name'
          ),

          LREntryBox(
            textController: _emailController, 
            label: 'Email Address*',
            keyboard: 'email'
          ),

          LREntryBox(
            textController: _usernameController, 
            label: 'Username*',
            keyboard: 'text'
          ),

          LREntryBox(
            textController: _passwordController, 
            label: 'Password*',
            keyboard: 'password',
            isPassword: true
          ),

          // Sign Up.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal:50),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton(
                onPressed: () {
                  String firstName = _firstNameController.text;
                  String lastName = _lastNameController.text;
                  String email = _emailController.text;
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                    
                  // Perform login logic here
                  if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
                    // for debug purposes, it is routing to the home page with any input in email, username, and password
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }

                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter email, username, and password')),
                    );
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 18,
                  )
                ),
              ),
            ),
          ),


          // Have an account? Log in.
          Padding(
            padding: const EdgeInsets.symmetric(vertical:0, horizontal:50),
            child: Container(
              alignment: AlignmentDirectional.center,
              
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }, 
                child: RichText(
                  text: const TextSpan(
                    text: "Have an account? ",
                    style:TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight:FontWeight.bold
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Log In.",
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