import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'otter.dart';

import 'package:http/http.dart' as http;

class OtterReader {
  Future<List<Otter>> read(String fileName) async {
    final String content = await rootBundle.loadString(fileName);
    return parse(content);
  }

  // json array to list
  List<Otter> parse(String s) {
    List res = json.decode(s);
    return res.map(parseOtter).toList();
  }

  // take some json properties and return an otter object from it
  Otter parseOtter(properties) {
    String name = properties["name"];
    String common = properties["common"];
    String desc = properties["desc"];
    String link = properties["link"];
    String detail = properties["detail"];
    String imageUrl = properties["imgs"][0];

    return Otter(name, common, desc, link, imageUrl, detail);
  }
}
