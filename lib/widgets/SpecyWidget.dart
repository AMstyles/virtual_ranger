import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/SpecyPage.dart';

import '../models/Specy.dart';

class SpecyWidg extends StatelessWidget {
  SpecyWidg({Key? key, required this.specy}) : super(key: key);
  Specy specy;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SpecyPage(
            specy: specy,
          );
        }));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                specy.english_name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
