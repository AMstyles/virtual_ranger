import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField(
      {Key? key,
      required this.hint,
      required this.controller,
      this.obscureText})
      : super(key: key);
  final String hint;
  final TextEditingController controller;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: CupertinoTextField(
        obscureText: obscureText ?? false,
        style: TextStyle(
          color: Colors.grey.shade600,
          //fontSize: 14,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        controller: controller,
        placeholder: hint,
      ),
    );
  }
}
