import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ExperienceClass.dart';
import 'main.dart';

class ExperienceDetail extends StatelessWidget {
  final ExperienceClass exp;
  ExperienceDetail(this.exp);

  Future<void> delete(ExperienceClass e) async {
    final res = await supabase
        .from('experiences')
        .delete()
        .match({'id': e.id.toString()}).execute();
  }

  @override
  Widget build(BuildContext context) {
    String title = exp.title;
    String desc = exp.description;
    String imageUrl =(exp.imageUrl);

    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            (imageUrl == "" || imageUrl == "null" || imageUrl == null
                ? Text(" ")
                : SizedBox(
                    height: 400, child: Image.network((imageUrl)))),
            Text("Title $title",
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    ?.copyWith(color: Colors.black)),
            Text("Description $desc",
                style: Theme.of(context)
                    .primaryTextTheme
                    .subtitle1
                    ?.copyWith(color: Colors.black)),
            Container(
              child: FloatingActionButton(
                onPressed: () {
                  delete(exp);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.delete),
                backgroundColor: Colors.lightBlue,
                tooltip: "Delete",
              ),
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(right: 20),
            ),
          ],
        ),
      ),
    );
  }
}
