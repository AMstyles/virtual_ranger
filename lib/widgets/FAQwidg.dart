import 'package:flutter/material.dart';

class FAQWidg extends StatelessWidget {
  const FAQWidg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '1. What is the speed limit?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              'General rules of road apply within the reserve and speed limit is 20km/h'),
          Divider()
        ],
      ),
    );
  }
}
