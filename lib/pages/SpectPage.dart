import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/news.dart';

class SpecyPage extends StatelessWidget {
  const SpecyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('specy Name'),
      ),
      body: ListView(shrinkWrap: true, children: [
        Image.network('https://picsum.photos/250?image=9'),
        SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
