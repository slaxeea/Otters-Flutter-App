import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'styles.dart';
import 'ExperienceClass.dart';

Widget experience() {
  List<ExperienceClass> experienceList = [
  ];

  return Container(
      child: Column(children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Experiences", style: title, textAlign: TextAlign.start),
    ),
    SizedBox(
      height: 400,
      child: ListView.builder(
          itemCount: experienceList.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      experienceList[index].title,
                      style: text,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      experienceList[index].description,
                      style: text,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                decoration: boxdeco,
              ),
            );
          }),
    ),
    Container(
      child: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
        tooltip: "New",
      ),
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.only(right: 20),
    ),
  ]));
}
