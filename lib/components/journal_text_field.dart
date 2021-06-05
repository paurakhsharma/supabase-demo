import 'package:flutter/material.dart';

class JournalTextField extends StatelessWidget {
  const JournalTextField({
    Key? key,
    required this.controller,
    required this.title,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.all(10)
  });

  final TextEditingController controller;
  final int maxLines;
  final String title;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        maxLines: maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$title cannot be empty';
          }
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          hintText: title,
          contentPadding: contentPadding,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2.0,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}
