import 'package:flutter/material.dart';
import 'otter_list.dart';
import 'otter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: OtterList(),
    );
  }
}

class OtterPage extends StatelessWidget {
  final Otter otter;
  OtterPage(this.otter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otter.common)),
      body: Column(
        children: [
          Image.network(otter.imageUrl),
          Text("Details", style: Theme.of(context).primaryTextTheme.headline6?.copyWith(color: Colors.black)),
          Text(otter.detail, style: Theme.of(context).primaryTextTheme.subtitle1?.copyWith(color: Colors.black)),
          
        ],
      ),
    );
  }
}
