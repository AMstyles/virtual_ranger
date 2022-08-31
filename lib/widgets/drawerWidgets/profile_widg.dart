import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/services/page_service.dart';

import '../../models/preset_styles.dart';

class DrawerProfile extends StatelessWidget {
  const DrawerProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //go to profile page
      },
      child: DrawerHeader(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Provider.of<UserProvider>(context).user!.isImageNull()
                  ? const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('lib/assets/noPro.jpg'),
                    )
                  : CircleAvatar(
                      backgroundImage: (Provider.of<UserProvider>(context)
                                  .user!
                                  .image! ==
                              "")
                          ? AssetImage('lib/assets/noPro.jpg') as ImageProvider
                          : CachedNetworkImageProvider(
                              Provider.of<UserProvider>(context).user!.image!),
                      radius: 50,
                    ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    Provider.of<UserProvider>(context).user!.name,
                    style: profTextStyle,
                  ),
                ),
              )
            ],
          ),
        ],
      )),
    );
  }
}
