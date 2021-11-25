import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'styles.dart';
import 'ExperienceClass.dart';

class experience extends StatefulWidget {
  experience({Key key}) : super(key: key);

  @override
  _experienceState createState() => _experienceState();
}

class _experienceState extends State<experience> {
  final Future<FirebaseApp> initialization = Firebase.initializeApp();
  

  @override
  Widget build(BuildContext context) {
    List<ExperienceClass> experienceList = [];
    // initialization.then((value) => {FirebaseAuth auth = FirebaseAuth.instance});
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => (newExperience())),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.lightBlue,
          tooltip: "New",
        ),
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.only(right: 20),
      ),
    ]));
  }
}

class newExperience extends StatefulWidget {
  @override
  _newExperienceState createState() => _newExperienceState();
}

class _newExperienceState extends State<newExperience> {
  @override
  Widget build(BuildContext context) {
    void saveExperince(String title, String description) {
      setState(() {
        ExperienceClass experience = new ExperienceClass(title, description);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Experience"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
                      )),
                    ),
                    Container(
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.save),
                        backgroundColor: Colors.lightBlue,
                        tooltip: "Save",
                      ),
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 20),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
