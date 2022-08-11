import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Custom/AnimeVals.dart';

class RulesPage extends StatefulWidget {
  RulesPage({Key? key}) : super(key: key);

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  late String rules;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
          ),
          title: const Text('Rules And regulations')),
      body: ListView(
        children: [
          Container(
            //alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.brown.shade600,
            child: const Center(
              child: Text(
                textAlign: TextAlign.center,
                'We would like tofocus on driving advice where the safe driving is in the hands of the visitor. We would like to provide the following recommendations',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 14,
            ),
            child: Text(
              'okay',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
