import 'package:flutter/material.dart';

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
            children: const [
              Hero(
                tag: 'pic',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  radius: 50,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    'NAME  SURNAME',
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
