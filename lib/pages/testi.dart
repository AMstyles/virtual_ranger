import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';

class TestiPage extends StatefulWidget {
  TestiPage({Key? key}) : super(key: key);

  @override
  State<TestiPage> createState() => _TestiPageState();
}

class _TestiPageState extends State<TestiPage> {
  void getIm() async {
    Dio dio = Dio();
    String url =
        'https://dinokengapp.co.za/admin/animal_image/101_286%20African%20Snipe%202515_2705%20Mankwe%20Dam%20001%20Of%2010Oct15.JPG';
    String filePath = UserData.path + url.split('/').last;
    await dio.download(url, filePath);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Testimonials')),
      body: Center(
        child: Column(
          children: [
            CupertinoButton(child: Text('Download'), onPressed: getIm),
          ],
        ),
      ),
    );
  }
}
