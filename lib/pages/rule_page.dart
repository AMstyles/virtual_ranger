import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Custom/AnimeVals.dart';

class RulesPage extends StatefulWidget {
  RulesPage({Key? key}) : super(key: key);

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
          ),
          title: const Text('Rules')),
    );
  }
}
