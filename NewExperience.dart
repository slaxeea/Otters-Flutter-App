import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'auth.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class newExperience extends StatefulWidget {
  @override
  _newExperienceState createState() => _newExperienceState();
}

class _newExperienceState extends State<newExperience> {
  XFile imageFile;
  String imagePath;
  String title = "";
  String desc = "";
  String imageUrl = "";

  // Save the experience to the database
  Future<PostgrestResponse> saveExperience(
      String title, String desc, String imageUrl) async {
    String id = supabase.auth.currentUser.id;
    final response = await supabase.from('experiences').insert([
      {'userid': id, 'title': title, 'desc': desc, 'imageUrl': imageUrl}
    ]).execute();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    Future imageSelector(BuildContext context, String pickerType) async {
      ImagePicker img = new ImagePicker();
      switch (pickerType) {
        case "gallery":
          imageFile = (await img.pickImage(
              source: ImageSource.gallery, imageQuality: 90));
          break;

        case "camera":
          imageFile = (await img.pickImage(
              source: ImageSource.camera, imageQuality: 90));
          break;
      }

      if (imageFile != null) {
        print("You selected  image : " + imageFile.path);

        // Upload the file to the database
        final dynamic file = File(imageFile.path);
        // Save the file with a random number (this is not a good method haha)
        String rand = Random().nextInt(1000000).toString();
        String path = getUserId() + "/" + rand;

        final res = await supabase.storage.from('images').upload(path, file,
            fileOptions: FileOptions(cacheControl: '3600', upsert: false));

        String pathInDb =
            "https://eoshhzqqdhzcowuvurqc.supabase.in/storage/v1/object/public/images/" +
                getUserId() +
                "/" +
                rand;

        // Save the path for the image to the experience table
        setState(() {
          imageUrl = pathInDb;
        });
      }
    }

    // Display the option for the user to take a photo or
    // select one from their phone
    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      title: new Text('Gallery'),
                      onTap: () => {
                            imageSelector(context, "gallery"),
                            Navigator.pop(context),
                          }),
                  new ListTile(
                    title: new Text('Camera'),
                    onTap: () => {
                      imageSelector(context, "camera"),
                      Navigator.pop(context)
                    },
                  ),
                ],
              ),
            );
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
                          onChanged: (String value) {
                            setState(() {
                              title = value.toString();
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
                              desc = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description",
                          )),
                    ),
                    (imageUrl == ""
                        ? Text(" ")
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              File(imageFile.path),
                              height: 300,
                            ),
                          )),
                    (imageFile == null
                        ? ElevatedButton(
                            child: Text('Add Photo'),
                            onPressed: () {
                              _settingModalBottomSheet(context);
                            })
                        : Text(" ")),
                    Container(
                      child: FloatingActionButton(
                        onPressed: () {
                          // Write the experience to the database
                          saveExperience(title, desc, imageUrl);
                          
                          // Return to the previous widget
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
