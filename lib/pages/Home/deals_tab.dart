import 'package:flutter/material.dart';

class DealsTab extends StatefulWidget {
  DealsTab({Key? key}) : super(key: key);

  @override
  State<DealsTab> createState() => _DealsTabState();
}

class _DealsTabState extends State<DealsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('hello, Deals'));
  }
}
