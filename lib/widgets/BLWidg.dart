import 'package:flutter/material.dart';

class BusinessListingWidg extends StatelessWidget {
  const BusinessListingWidg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          Image.network(
            '',
            cacheHeight: 50,
            width: 50,
          ),
          Column(
            children: [
              Text(
                "Heading",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text('data')
            ],
          )
        ],
      ),
    );
  }
}
