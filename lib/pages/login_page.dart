// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:journey_journal_app/components/api_service.dart';
import 'package:journey_journal_app/components/l_r_entry_box.dart';

import 'package:journey_journal_app/pages/home_page.dart';
import 'package:journey_journal_app/pages/register_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

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
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _doLogin,
                
                icon: _isLoading 
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : null,

                label: !_isLoading
                      ? const Text(
                          'Log In',
                          style: TextStyle(
                          fontSize: 18,
                          )
                        )
                      : const Text(''),

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
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
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

  void _doLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Perform login logic here
    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() => _isLoading = true); // Set loading state

      try {
        var credentials = await ApiService.login(email, password);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(
            credentials: credentials,
            email: email, // Pass email to HomeScreen
          )),
          (Route<dynamic> route) => false, 
        );
      } catch (e) {
        setState(() => _isLoading = false); // Reset loading state on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
    }
  }
}
