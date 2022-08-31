import 'package:flutter/material.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 8, 200, 104),
        radius: 20,
      ),
      title: Text('Animal'),
    );
  }
}
