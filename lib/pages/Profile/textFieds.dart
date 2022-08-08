import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField(
      {Key? key, required this.hint, required this.controller})
      : super(key: key);
  final String hint;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoTextField(
        controller: controller,
        placeholder: hint,
      ),
    );
  }
}
