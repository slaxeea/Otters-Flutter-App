import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezepte/otter_list.dart';
import 'ExperienceClass.dart';
import 'styles.dart';
import 'main.dart';
import 'auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class experience extends StatefulWidget {
  experience({Key key}) : super(key: key);

  @override
  _experienceState createState() => _experienceState();
}

class _experienceState extends State<experience> {
  List<ExperienceClass> experienceList = [];
  bool signedin = false;

  Future<PostgrestResponse> getExperiences() async {
    if (signedin) {
      experienceList.clear();
      String id = supabase.auth.currentUser.id;
      final response = await supabase
          .from('experiences')
          .select()
          .eq('userid', id)
          .execute();
      final data = response.data;
      List<ExperienceClass> temp = [];
      for (var i = 0; i < response.data.length; i++) {
        temp.add(new ExperienceClass(
            response.data[i]['title'], response.data[i]['desc']));
      }
      setState(() {
        experienceList = temp;
      });
      final error = response.error;
      return response;
    } else
      return null;
  }

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange((event, session) {
      if (event.toString() == "AuthChangeEvent.signedIn" ||
          event.toString() == "AuthChangeEvent.signedUp") {
        setState(() {
          signedin = true;
        });
        getExperiences();
        print("authentification complete");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!signedin) {
      return Container(
        child: Center(
          child: Column(
            children: [
              Text(
                "Please Login to view your experiences",
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                  child: Text('Login'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }),
              Text(
                "or",
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                  child: Text('Signup'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  }),
            ],
          ),
        ),
      );
    } else {
      return Container(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Experiences", style: title, textAlign: TextAlign.start),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: experienceList.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
}

class newExperience extends StatefulWidget {
  @override
  _newExperienceState createState() => _newExperienceState();
}

class _newExperienceState extends State<newExperience> {
  Future<PostgrestResponse> saveExperience(String title, String desc) async {
    String id = supabase.auth.currentUser.id;
    final response = await supabase.from('experiences').insert([
      {'userid': id, 'title': title, 'desc': desc}
    ]).execute();
    return response;
  }

  String title = "";
  String desc = "";
  @override
  Widget build(BuildContext context) {
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
                          onChanged: (String value) {
                            setState(() {
                              desc = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Title",
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          onChanged: (String value) {
                            setState(() {
                              title = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description",
                          )),
                    ),
                    Container(
                      child: FloatingActionButton(
                        onPressed: () {
                          saveExperience(title, desc)
                              .then((value) => print(value.data));
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
