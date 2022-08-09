import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/SpectPage.dart';

class SpecyWidg extends StatelessWidget {
  const SpecyWidg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SpecyPage();
        }));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Blue Waxbill",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
