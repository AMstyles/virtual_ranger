import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/models/event.dart';

import '../../apis/eventapi.dart';
import '../../models/constants.dart';
import '../../services/page_service.dart';
import '../../widgets/eventWidg.dart';

class DealsTab extends StatefulWidget {
  DealsTab({Key? key}) : super(key: key);

  @override
  State<DealsTab> createState() => _DealsTabState();
}

class _DealsTabState extends State<DealsTab>
    with AutomaticKeepAliveClientMixin<DealsTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: Provider.of<UserProvider>(context).isOffLine ?? false
          ? Eventapi.getEventsFromLocal()
          : Eventapi.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            cacheExtent: 10,
            addAutomaticKeepAlives: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return EventWidg(event: snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
          child: LoadingBouncingGrid.square(
            backgroundColor: MyColors.primaryColor,
            duration: Duration(milliseconds: 500),
            inverted: true,
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
