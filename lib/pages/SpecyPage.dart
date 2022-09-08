import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/apis/Animal&Plants_apis.dart';
import 'package:virtual_ranger/models/Specy.dart';
import 'package:virtual_ranger/models/animal_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/constants.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';

class SpecyPage extends StatefulWidget {
  SpecyPage({Key? key, required this.specy}) : super(key: key);
  Specy specy;

  @override
  State<SpecyPage> createState() => _SpecyPageState();
}

class _SpecyPageState extends State<SpecyPage> {
  late bool isOffline;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserData.getOfflineMode().then((value) => setState(() {
          isOffline = value;
          print(value);
        }));
  }

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(.3),
            ),
            child: Center(
              child: Icon(
                Platform.isAndroid ? Icons.arrow_back : CupertinoIcons.back,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        title: Text(widget.specy.english_name),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 350,
            child: FutureBuilder<List<SpecyImage>>(
              future: Provider.of<UserProvider>(context).isOffLine ?? false
                  ? Imageapi.getImagesFromLocal(widget.specy)
                  : Imageapi.getImages(widget.specy),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length == 1) {
                    return Pages(
                      specyImage: snapshot.data![0],
                    );
                  } else {
                    return Stack(
                      alignment: const Alignment(0, .9),
                      children: [
                        PageView.builder(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Pages(
                              specyImage: snapshot.data![index],
                            );
                          },
                        ),
                        SmoothPageIndicator(
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.black.withOpacity(.5),
                            activeDotColor: Colors.white,
                          ),
                          controller: _controller,
                          count: snapshot.data!.length,
                        )
                      ],
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text("error: ${snapshot.error}");
                }
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
          //!I'm defeated
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

}

class Pages extends StatefulWidget {
  Pages({Key? key, required this.specyImage}) : super(key: key);
  SpecyImage specyImage;

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("here we go booooy");
    print(widget.specyImage.images);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provider.of<UserProvider>(context).isOffLine ?? false
          ? Image.file(
              File('${UserData.path}/${widget.specyImage.images}'),
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              imageUrl: BASE_IMAGE_URL + widget.specyImage.images,
              fit: BoxFit.cover,
            ),
    );
  }
}
