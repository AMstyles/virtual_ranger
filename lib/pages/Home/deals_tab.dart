import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/event.dart';

import '../../apis/eventapi.dart';
import '../../widgets/eventWidg.dart';

class DealsTab extends StatefulWidget {
  DealsTab({Key? key}) : super(key: key);

  @override
  State<DealsTab> createState() => _DealsTabState();
}

class _DealsTabState extends State<DealsTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: Eventapi.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return EventWidg(event: snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
