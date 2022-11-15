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
  late Future<List<FAQ>> _faq = _faq =
      Provider.of<UserProvider>(context).isOffLine ?? false
          ? FAQapi.getFAQFromLocal()
          : FAQapi.getFAQ();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        future: _faq,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return FAQWidg(faq: snapshot.data![index]);
                },
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: ListView(
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          snapshot.error
                                  .toString()
                                  .toLowerCase()
                                  .contains("dinokeng")
                              ? const Text(
                                  "No Internet Connection",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 19),
                                )
                              : const Text(
                                  "Error",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 19),
                                ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _faq =
                              Provider.of<UserProvider>(context, listen: false)
                                          .isOffLine ??
                                      false
                                  ? FAQapi.getFAQFromLocal()
                                  : FAQapi.getFAQ();
                          ;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.all(10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green,
                                width: 1,
                              )),
                          child: Text("Retry")),
                    )
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
