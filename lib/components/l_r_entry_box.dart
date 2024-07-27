import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

enum RowPlacement {solo, left, right, middle}

class LREntryBox extends StatelessWidget {

  const LREntryBox({
    super.key,
    required this.textController,
    required this.label,
    this.keyboard = 'text',
    this.isPassword = false,
    this.validator,
    this.autovalidate = false,
    this.rowPlacement = RowPlacement.solo

  });

  static final fieldType = {
    'email': TextInputType.emailAddress,
    'name': TextInputType.name,
    'password': TextInputType.visiblePassword,
    'text': TextInputType.text,
  };


  final TextEditingController textController;
  final String label;

  final RowPlacement rowPlacement;
  final String keyboard;
  final bool isPassword;

  // 
  

  final FieldValidator? validator;
  final bool autovalidate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (){
        switch (rowPlacement){
          case RowPlacement.solo: 
            return const EdgeInsets.symmetric(vertical:10, horizontal:50);
          case RowPlacement.left:
            return const EdgeInsets.only(left:50, top: 10, bottom:10 , right: 10);
          case RowPlacement.right:
            return const EdgeInsets.only(left:10, top: 10, bottom:10 , right: 50);
          case RowPlacement.middle:
            return const EdgeInsets.all(10);
        }
      }(),
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          labelText: label,
          errorMaxLines: 2,
          border: const OutlineInputBorder(),
        ),
        keyboardType: fieldType[keyboard],
        obscureText: isPassword,
        onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: validator?.call,
        autovalidateMode: autovalidate ? AutovalidateMode.onUserInteraction: AutovalidateMode.disabled
      ),
    );
  }
}