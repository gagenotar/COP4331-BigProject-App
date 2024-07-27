import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:journey_journal_app/components/api_service.dart';

import 'package:journey_journal_app/pages/home_page.dart';

class EmailVerificationPage extends StatefulWidget{
  const EmailVerificationPage({
    super.key,
    required this.email,
    required this.password
    });

  final String email;
  final String password;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {

  final TextEditingController _textController = TextEditingController();

  final _errorController = StreamController<ErrorAnimationType>();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String currentText = "";

  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Form(
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
                'Enter the code we sent to ${_obscureEmail(widget.email)}',
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
                controller: _textController,
                onCompleted: (v) {
                  _doConfirm();
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),

        
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal:50),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _doConfirm,
                  
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
      )
    );
  }

  void _doConfirm() async{
    String email = widget.email;
    String code = _textController.text;

    // Perform login logic here
    if (_formkey.currentState!.validate()) {
    
      setState(() => _isLoading = true);
      var post = ApiService.verifyCode( email, code);

      post.then((var res) {
        _doLogin();
      }).catchError((e) {
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
  
  void _doLogin() async{
    String email = widget.email;
    String password = widget.password;
      
    if (_formkey.currentState!.validate()) {
      // Perform login logic here
      setState(() => _isLoading = true);

      var credentials = ApiService.login(email, password);

      credentials.then((var value){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(credentials: value, email: email)),
          (Route<dynamic> route) => false, 
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