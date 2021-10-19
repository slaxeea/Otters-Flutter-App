import 'package:flutter/material.dart';
import 'otter.dart';
import 'main.dart';
import 'otter_reader.dart';

class OtterList extends StatefulWidget {
  @override
  _OtterListState createState() => _OtterListState();
}

class _OtterListState extends State<OtterList> {
  List<Otter> otters;

  @override
  void initState() {
    super.initState();
    OtterReader().read("data/otters.json").then((otters) {
      setState(() {
        this.otters = otters;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Otter-Library")),
      body: otters == null ? buildWaitingWidget() : buildOtterWidget(),
    );
  }

  Widget buildWaitingWidget() {
    return Center(child: Text("Otter werden geladen..."));
  }

  Widget buildOtterWidget() {
    final listTiles = this.otters.map(listToMap).toList();
    return ListView(children: listTiles);
  }

  ListTile listToMap(otter) {
    return ListTile(
        title: Text(otter.common),
        onTap: () {
          toNextPage(Otter(otter.name, otter.common, otter.desc, otter.link, otter.imageUrl, otter.detail));
        });
  }

  void toNextPage(Otter otter) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => OtterPage(otter)));
  }
}
