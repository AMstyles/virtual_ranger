import 'package:flutter/material.dart';

class BeaconInfo extends StatelessWidget {
  const BeaconInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Image.network(
          'https://images.unsplash.com/photo-1664539545134-7017e0173232?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1035&q=80',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
