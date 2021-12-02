import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rezepte/experience.dart';
import 'package:rezepte/otter_list.dart';
import 'ExperienceClass.dart';
import 'styles.dart';
import 'main.dart';
import 'auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class ExperienceDetail extends StatelessWidget {
  final ExperienceClass exp;
  ExperienceDetail(this.exp);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(exp.title, style: text,),
    );
  }
}
