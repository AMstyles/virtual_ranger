import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/faq.dart';

class FAQWidg extends StatelessWidget {
  const FAQWidg({Key? key, required this.faq}) : super(key: key);

  final FAQ faq;

  @override
  Widget build(BuildContext context) {
    return
        //expansion tile
        Padding(
      padding: const EdgeInsets.all(5.0),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.grey[100],
        collapsedIconColor: Colors.blueGrey,
        title: Text(faq.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(faq.answer,
                style: const TextStyle(
                  fontSize: 16,
                )),
          ),
        ],
      ),
    );

    ; /*Padding(
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
    );*/
  }
}
