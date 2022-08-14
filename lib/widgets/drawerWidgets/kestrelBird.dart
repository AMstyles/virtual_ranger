import 'package:flutter/material.dart';

class KestrelBirds extends StatefulWidget {
  KestrelBirds({Key? key}) : super(key: key);

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
              return Bird(index: index);
            })),
      ),
    );
  }
}

class Bird extends StatelessWidget {
  const Bird({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Image.asset(
            index != 11
                ? 'lib/assets/kestrel_empty.png'
                : 'lib/assets/kestrel_free.png',
          ),
          Image.asset(
            'lib/assets/kestrel_check.png',
            width: 25,
          ),
        ],
      ),
    );
  }
}
