import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool hasError;
  const CustomTextField({super.key, required this.controller, required this.hintText, required this.obscureText, required this.hasError});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              width: double.infinity,
              height: 45,
              child: TextField(
              style: const TextStyle(fontSize: 15.0),
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0, horizontal: 10.0
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: hasError ?  Colors.red :  const Color.fromARGB(255, 196, 196, 196))
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey)
              ),
            ),
            );
  }
}