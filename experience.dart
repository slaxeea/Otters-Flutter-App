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
  bool isloggedin() {
    return supabase.auth.currentUser != null;
  }

  List<ExperienceClass> experienceList = [];
  Future<PostgrestResponse> getExperiences() async {
    String id = supabase.auth.currentUser.id;
    print(id);
    final response =
        await supabase.from('experiences').select().eq('userid', id).execute();
    final data = response.data;
    final error = response.error;
    return response;
  }

  @override
  void initState() {
    super.initState();
    getExperiences().then((response) {
      setState(() {
        for (var i = 0; i < response.data.length; i++) {
          experienceList.add(new ExperienceClass(
              response.data[i]['title'], response.data[i]['desc']));
        }
      });
      print(experienceList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(isloggedin());
    if (!isloggedin()) {
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
                      MaterialPageRoute(builder: (context) => Login()),
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
                          MaterialPageRoute(builder: (context) => experience());
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
