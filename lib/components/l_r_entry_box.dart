import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LREntryBox extends StatelessWidget {

  const LREntryBox({
    super.key,
    required this.textController,
    required this.label,
    this.keyboard = 'text',
    this.isPassword = false,
    this.validator,
    this.autovalidate = false
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

  final FieldValidator? validator;
  final bool autovalidate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10, horizontal:50),
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          labelText: label,
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