import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'otter.dart';
import 'main.dart';
import 'experience.dart';
import 'otter_reader.dart';

class OtterList extends StatefulWidget {
  @override
  _OtterListState createState() => _OtterListState();
}

class _OtterListState extends State<OtterList> {
  List<Otter> otters;

  @override
  Future<void> initState() {
    super.initState();
    OtterReader().read("data/otters.json").then((otters) {
      setState(() {
        this.otters = otters;
      });
    });
  }

  int _selectedIndex = 1;
  String searchedQuery = "";

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    final List _widgetOptions = [
      experience(),
      (otters == null ? buildWaitingWidget() : buildOtterWidget()),
      (Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Search for an otter',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'otter name or species name'),
                onChanged: (String value) {
                  setState(() {
                    searchedQuery = value;
                  });
                },
              ),
            ),
            Container(
              height: 400,
              width: 500,
              child: searchResultWidget(searchedQuery),
            ),
          ])),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Otter-Library")),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Experience',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget searchResultWidget(String query) {
    List<Otter> filteredOtters = [];
    if (query != null && query != "") {
      try {
        otters.forEach((element) {
          if (element.common.toLowerCase() == query.toLowerCase() ||
              element.name.toLowerCase() == query.toLowerCase() ||
              element.common.toLowerCase().contains(query.toLowerCase()) ||
              element.name.toLowerCase().contains(query.toLowerCase())) {
            filteredOtters.add(element);
          }
        });
        return ListView.builder(
            itemCount: filteredOtters.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  toNextPage(filteredOtters[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Image(
                            image: Image.network(filteredOtters[index].imageUrl)
                                .image,
                            width: 200),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  filteredOtters[index].common,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  filteredOtters[index].desc,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                  ),
                ),
              );
            });
      } catch (e) {
        print(e);
        return (Text("No otter found"));
      }
    } else {
      return (Text(""));
    }
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
