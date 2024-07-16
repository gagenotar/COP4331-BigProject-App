import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:journey_journal_app/pages/login_page.dart';

import 'package:journey_journal_app/components/api_service.dart';
import 'package:journey_journal_app/components/l_r_entry_box.dart';

import 'package:form_field_validator/form_field_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      //resizeToAvoidBottomInset: false,
      body: Form(
        key: _formkey,
        child: ListView(
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
              keyboard: 'email',
              validator: MultiValidator([
                RequiredValidator(errorText: "* Required"),
                EmailValidator(errorText: "Not a valid email address.")
                ]),
              autovalidate: _autovalidate,
            ),
        
            LREntryBox(
              textController: _usernameController, 
              label: 'Username*',
              keyboard: 'text',
              validator:RequiredValidator(errorText: "* Required"),
              autovalidate: _autovalidate,
            ),
        
            LREntryBox(
              textController: _passwordController, 
              label: 'Password*',
              keyboard: 'password',
              isPassword: true,
              validator: MultiValidator([
                RequiredValidator(errorText: "* Required"),
                MinLengthValidator(8,errorText: "Password must be at least 8 characters"),
                PatternValidator(r'[A-Z]', errorText: "Password must contain at least one uppercase letter"),
                PatternValidator(r'[0-9]', errorText: "Password must contain at least one number"),
                PatternValidator(r'[!@#$%^&*]', errorText: "Password must contain at least one special character")
              ]),
              autovalidate: true
            ),
        
            // Sign Up.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal:50),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _doRegister,
                  
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
                            'Sign Up',
                            style: TextStyle(
                            fontSize: 18,
                            )
                          )
                        : const Text(''),
        
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
        ),
      )
    );
  }

  void _doRegister() async{
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Perform login logic here
    if (_formkey.currentState!.validate()) {
    
      setState(() => _isLoading = true);
      var post = ApiService.register(firstName, lastName, email, username, password);

      post.then((var res) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e)),
        );
        setState(() => _isLoading = false);
      });
    } 
    else {
      setState(() => _isLoading = false);
      setState(() => _autovalidate = true);
    }
  }
}