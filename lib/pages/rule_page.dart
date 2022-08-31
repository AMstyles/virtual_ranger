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
          title: const Text('Rules And Regulations')),
      body: ListView(
        children: [
          Container(
            //alignment: Alignment.center,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration( borderRadius: BorderRadius.circular(8),
                color: MyColors.secondaryColor ),
            padding: const EdgeInsets.symmetric(vertical: 8),

            child: const Center(
              child: Text(
                textAlign: TextAlign.center,
                'We would like tofocus on driving advice where the safe driving is in the hands of the visitor. We would like to provide the following recommendations',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Colors.white,
                ),
                //      margin: const EdgeInsects.only(left:20.0, right: 20.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 14,
            ),
            child: Text(
              constRulesAndRegulations,
              textAlign: TextAlign.left,
              style: TextStyle(color: MyColors.secondaryColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
