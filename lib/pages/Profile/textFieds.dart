import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class ProfileTextField1 extends StatelessWidget {
  ProfileTextField1(
      {Key? key,
      required this.hint,
      required this.voidCallback,
      required this.controller})
      : super(
          key: key,
        );
  VoidCallback voidCallback;
  final String hint;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoTextField(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.yellow,
            width: 6,
          ),
        ),
        onTap: voidCallback,
        controller: controller,
        placeholder: hint,
      ),
    );
  }
}
