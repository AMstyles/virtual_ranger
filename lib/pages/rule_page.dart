import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/constants.dart';
import 'package:virtual_ranger/services/getRequests.dart';

import 'Custom/AnimeVals.dart';

class RulesPage extends StatefulWidget {
  RulesPage({Key? key}) : super(key: key);

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  //late String rules;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //rules = something();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
          ),
          title: const Text('Rules and Regulations')),
      body: ListView(
        children: [
          Container(
            //alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: MyColors.secondaryColor,
            child: const Center(
              child: Text(
                textAlign: TextAlign.center,
                'We would like to focus on driving advice where the safe driving is in the hands of the visitor. We would like to provide the following recommendations',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 14,
            ),
            child: Text(
              constRulesAndRegulations,
              textAlign: TextAlign.left,
              style: TextStyle(color: MyColors.secondaryColor, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
