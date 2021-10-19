import 'dart:convert';
import 'package:flutter/services.dart';
import 'otter.dart';

class OtterReader {
  Future<List<Otter>> read(String fileName) async {
    final String content = await rootBundle.loadString(fileName);
    return parse(content);
  }

  List<Otter> parse(String s) {
    List res = json.decode(s);
    return res.map(parseOtter).toList();
  }

  Otter parseOtter(properties) {
    print(properties);
    String name = properties["name"];
    String common = properties["common"];
    String desc = properties["desc"];
    String link = properties["link"];
    String detail = properties["detail"];
    String imageUrl = properties["imgs"][0];

    return Otter(name, common, desc, link, imageUrl, detail);
  }
}
