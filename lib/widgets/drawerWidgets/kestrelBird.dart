import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/page_service.dart';

class KestrelBirds extends StatefulWidget {
  KestrelBirds({Key? key, required this.count}) : super(key: key);
  int count;

  @override
  State<KestrelBirds> createState() => _KestrelBirdsState();
}

class _KestrelBirdsState extends State<KestrelBirds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Center(
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: ((context, index) {
              return Bird(
                index: index,
              );
            })),
      ),
    );
  }
}

class Bird extends StatefulWidget {
  Bird({Key? key, required this.index}) : super(key: key);
  int index;

  @override
  State<Bird> createState() => _BirdState();
}

class _BirdState extends State<Bird> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Image.asset(
            widget.index != 11
                ? 'lib/assets/kestrel_empty.png'
                : 'lib/assets/kestrel_free.png',
          ),
          (widget.index <=
                  (Provider.of<UserProvider>(context).user!.kestle_points - 1))
              ? Image.asset(
                  'lib/assets/kestrel_check.png',
                  width: 25,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
