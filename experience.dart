import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otter_library/NewExperience.dart';
import 'ExperienceClass.dart';
import 'ExperienceDetail.dart';
import 'styles.dart';
import 'main.dart';
import 'NewExperience.dart';
import 'auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class experience extends StatefulWidget {
  experience({Key key}) : super(key: key);

  @override
  _experienceState createState() => _experienceState();
}

class _experienceState extends State<experience> {
  List<ExperienceClass> experienceList = [];
  bool signedin = supabase.auth.currentUser != null;

  // Get all the experiences of this user
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
        // Convert the data to experienc objects
        temp.add(new ExperienceClass(
            response.data[i]['title'],
            response.data[i]['desc'],
            response.data[i]['id'].toString(),
            response.data[i]['imageUrl'].toString()));
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
    if (signedin) {
      getExperiences();
    }
    supabase.auth.onAuthStateChange((event, session) {
      if (event.toString() == "AuthChangeEvent.signedIn" ||
          event.toString() == "AuthChangeEvent.signedUp") {
        setState(() {
          signedin = true;
        });
        getExperiences();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Display the login and signup buttons
    // if the user is not authenticated
    if (!signedin) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Please",
                style: title,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    key: Key("tologinbtn"),
                    child: Text('Login'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    }),
              ),
              Text(
                "or",
                style: title,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    child: Text('Signup'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    }),
              ),
              Text("to view your experiences", style: title),
            ],
          ),
        ),
      );
    } else {
      return RefreshIndicator(
          onRefresh: getExperiences,
          child: Column(children: <Widget>[
            Expanded(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: experienceList.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Open the detailed page for the experience
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ExperienceDetail(experienceList[index])));
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: boxdeco,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                experienceList[index].title,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              experienceList[index].imageUrl == null
                                  ? Text("")
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        experienceList[index].imageUrl,
                                        height: 180,
                                      ),
                                    ),
                              Text(
                                experienceList[index].description,
                                style: text,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
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
              padding: const EdgeInsets.only(right: 20, bottom: 20),
            ),
          ]));
    }
  }
}
