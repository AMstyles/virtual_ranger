import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/faq.dart';

class FAQWidg extends StatelessWidget {
  const FAQWidg({Key? key, required this.faq}) : super(key: key);

  final FAQ faq;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            faq.answer,
          ),
          const Divider()
        ],
      ),
    );
  }
}
