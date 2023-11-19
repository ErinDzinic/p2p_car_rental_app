import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? Function(String? value)? validator;
  final bool changeColors;
  final bool isPasswordField;

  const CustomTextFieldWidget(
      {super.key,
      required this.controller,
      required this.title,
      required this.validator,
      this.changeColors = false,
      this.isPasswordField = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: changeColors ? const TextStyle(color: Colors.white) : null,
      validator: validator,
      controller: controller,
      obscureText: isPasswordField ? true : false,
      decoration: InputDecoration(
        labelText: title,
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: changeColors ? Colors.white : Colors.black),
        ),
        labelStyle:
            TextStyle(color: changeColors ? Colors.teal[50] : Colors.teal),
      ),
    );
  }
}

class DigitTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? Function(String? value)? validator;

  const DigitTextFieldWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: title,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelStyle: const TextStyle(color: Colors.teal),
      ),
    );
  }
}
