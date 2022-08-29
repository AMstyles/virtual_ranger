import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/widgets/FAQwidg.dart';

import '../models/faq.dart';
import '../services/faqapi.dart';
import '../services/page_service.dart';
import 'Custom/AnimeVals.dart';

class FAQPage extends StatefulWidget {
  FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: const Text("FAQ"),
      ),
      body: FutureBuilder<List<FAQ>>(
        future: Provider.of<UserProvider>(context).isOffLine ?? false
            ? FAQapi.getFAQFromLocal()
            : FAQapi.getFAQ(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FAQWidg(faq: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
