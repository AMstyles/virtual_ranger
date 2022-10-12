import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension DoubleColor on Color {
  static Color fromDouble(double value) {
    return Color((value * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  static double fromColor(Color color) {
    return color.value.toDouble();
  }
}

Future<String> readSvgFile() async {
  final String response = await rootBundle.loadString('lib/svg/location.svg');
  return response;
}

class MapMarker {
  static Future<Uint8List> svgToPng(BuildContext context, String color,
      {int? svgWidth, int? svgHeight}) async {
    String svgString = await readSvgFile();
    final finalString = svgString.replaceAll("#FFF", color);

    DrawableRoot svgDrawableRoot = await svg.fromSvgString(finalString, "key");

    //change color of svgDrawableRoot

    // Parse the SVG file as XML
    XmlDocument document = XmlDocument.parse(svgString);

    // Getting size of SVG
    final svgElement = document.findElements("svg").first;

    final svgWidth = double.parse(svgElement.getAttribute("width")!);
    final svgHeight = double.parse(svgElement.getAttribute("height")!);
    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    double width = svgHeight * devicePixelRatio;
    double height = svgWidth * devicePixelRatio;

    // Convert to ui.Picture
    final picture = svgDrawableRoot.toPicture(
        size: Size(width, height),
        colorFilter:
            ColorFilter.mode(Colors.transparent, BlendMode.colorDodge));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the screen DPI
    final image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ImageByteFormat.png);

    return bytes!.buffer.asUint8List();
  }
}
