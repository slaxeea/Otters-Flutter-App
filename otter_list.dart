import 'package:flutter/material.dart';
import 'otter.dart';
import 'main.dart';
import 'otter_reader.dart';
import 'package:firebase_core/firebase_core.dart';

class OtterList extends StatefulWidget {
  @override
  _OtterListState createState() => _OtterListState();
}

class _OtterListState extends State<OtterList> {
  List<Otter> otters;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Future<void> initState() {
    super.initState();
    OtterReader().read("data/otters.json").then((otters) {
      setState(() {
        this.otters = otters;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Otter-Library")),
      body: otters == null ? buildWaitingWidget() : buildOtterWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Experience',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
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
          toNextPage(Otter(otter.name, otter.common, otter.desc, otter.link,
              otter.imageUrl, otter.detail));
        });
  }

  void toNextPage(Otter otter) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => OtterPage(otter)));
  }
}
