import 'package:flutter/material.dart';
import 'package:virtual_ranger/apis/Animal&Plants_apis.dart';
import 'package:virtual_ranger/models/Specy.dart';
import 'package:virtual_ranger/models/animal_image.dart';

import '../models/constants.dart';

class SpecyPage extends StatefulWidget {
  SpecyPage({Key? key, required this.specy}) : super(key: key);
  Specy specy;

  @override
  State<SpecyPage> createState() => _SpecyPageState();
}

class _SpecyPageState extends State<SpecyPage> {
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.specy.english_name),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        shrinkWrap: true,
        children: [
          FutureBuilder<List<SpecyImage>>(
            future: Imageapi.getImages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PageView.builder(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data![index].animal_id == widget.specy.id) {
                        print(snapshot.data![index].images);
                        return Image.network(
                          BASE_IMAGE_URL + snapshot.data![index].images,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const SizedBox();
                      }
                    });
              } else if (snapshot.hasError) {
                return Text("error: ${snapshot.error}");
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Scientific Name: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: widget.specy.scientific_name,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Higher Classification: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: widget.specy.higher_classification,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Rank: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: widget.specy.rank,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                const Text(
                  'Description: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.specy.description)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                const Text(
                  'Range And Habitat: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.specy.range_habitat)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                const Text(
                  'Behaviour: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.specy.behaviour)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Text>[
                const Text(
                  'Tags: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.specy.tags)
              ],
            ),
          ),
        ],
      ),
    );
  }

  //!Widgets
  Widget _buildImagePageView(List<String> images) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.network(
          images[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}
