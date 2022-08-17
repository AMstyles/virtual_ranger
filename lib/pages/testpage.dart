/*import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/animal_image.dart';

import '../apis/Animal&Plants_apis.dart';
import 'SpecyPage.dart';

class Playground extends StatefulWidget {
  Playground({Key? key}) : super(key: key);

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playground'),
      ),
      body: FutureBuilder<List<SpecyImage>>(
        future: Imageapi.getImages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data![4].images);
            return PageView.builder(
                controller: PageController(initialPage: 0),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Pages(specyImage: snapshot.data![index]);
                });
          } else if (snapshot.hasError) {
            return Text("error: ${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
*/