import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:journey_journal_app/components/api_service.dart';
import 'package:journey_journal_app/pages/login_page.dart';

class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _errorController = StreamController<ErrorAnimationType>();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool _codeSent = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: _codeSent ? resetPassword() : emailInput()
    );
  }

  Widget emailInput(){
    return Form(
      key: _formkey,
      child: Column(
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
            padding: const EdgeInsets.symmetric(vertical:10, horizontal:50),
            child: Text(
              'Enter your email address',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email address",
                errorMaxLines: 2,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    EmailValidator(errorText: "Not a valid email address.")
                    ]).call,
              autovalidateMode: AutovalidateMode.onUserInteraction
            )
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal:50),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _sendCode,
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
                          'Confirm',
                          style: TextStyle(
                          fontSize: 18,
                          )
                        )
                      : const Text(''),
              ),
            ),
          ),
        ]
      ),
    );
  }

  Widget resetPassword(){
    return Form(
      key: _formkey,
      child: Column(
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
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical:10, horizontal:50),
            child: Text(
              'Enter the code we sent to ${_obscureEmail(_emailController.text)}',
              style:const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: true,
              obscuringCharacter: '*',
              blinkWhenObscuring: true,
              blinkDuration: Durations.extralong4,
              animationType: AnimationType.fade,
              validator: PatternValidator(r'[0-9]', errorText: "Must contain only digits 0-9").call,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                activeColor: Colors.blue,
                inactiveColor: Colors.black54
              ),
              animationDuration: Durations.long4,
              backgroundColor: Colors.yellow.shade50,
              errorAnimationController: _errorController,
              keyboardType: TextInputType.number,
              controller: _codeController,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:10, horizontal:50),
            child: TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "New Password",
                errorMaxLines: 2,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: MultiValidator([
                    RequiredValidator(errorText: "* Required"),
                    MinLengthValidator(8,errorText: "Password must be at least 8 characters"),
                    PatternValidator(r'[A-Z]', errorText: "Password must contain at least one uppercase letter"),
                    PatternValidator(r'[0-9]', errorText: "Password must contain at least one number"),
                    PatternValidator(r'[!@#$%^&*]', errorText: "Password must contain at least one special character")
                  ]).call,
              autovalidateMode: AutovalidateMode.onUserInteraction
            )
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:10, horizontal:50),
            child: TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                errorMaxLines: 2,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: _confirmPasswordController.text == _confirmPasswordController.text 
                          ? MinLengthValidator(0,errorText: "").call
                          : MaxLengthValidator(0,errorText: "Passwords must match").call,              
              autovalidateMode: AutovalidateMode.onUserInteraction
            )
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal:50),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _resetPassword,
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
                          'Confirm',
                          style: TextStyle(
                          fontSize: 18,
                          )
                        )
                      : const Text(''),
              ),
            ),
          ),
        ]
      ),
    );
  }
  
  void _sendCode() async{
    if (_formkey.currentState!.validate()) {
      // Perform login logic here
      setState(() => _isLoading = true);

      var api = ApiService.forgotPassword(_emailController.text);

      api.then((_){
        setState(()=> _codeSent = true);
        setState (() => _isLoading = false);
      }).catchError((e) {
        _errorController.add(ErrorAnimationType.shake);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e)),
        );
        setState(() => _isLoading = false);
      });
    }
    else {
      setState(() => _isLoading = false);
    }
  }

  void _resetPassword() async{
    if (_formkey.currentState!.validate()) {
      // Perform login logic here
      setState(() => _isLoading = true);

      var api = ApiService.resetPassword(_emailController.text, _codeController.text, _passwordController.text);

      api.then((_) async{
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password Reset!")),
        );

        await Future.delayed(Durations.extralong4);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }).catchError((e) {
        _errorController.add(ErrorAnimationType.shake);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e)),
        );
        setState(() => _isLoading = false);
      });
    }
    else {
      setState(() => _isLoading = false);
    }
  }

  static String _obscureEmail(String email){
    List<String> splitEmail = email.split("@");
    return email.replaceRange(1,splitEmail[0].length,"*" * (splitEmail[0].length-2));
  }
}