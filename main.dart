import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'otter_list.dart';
import 'otter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

var url = 'https://eoshhzqqdhzcowuvurqc.supabase.co';
var anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzODI1NzExMCwiZXhwIjoxOTUzODMzMTEwfQ.rl0jjh5VOWvIYNBFg-UBbrhTAOwJ_JFfSjrsEtUjDNM';
final SupabaseClient supabase = SupabaseClient(url, anonKey);
SupabaseClient getSupabase() => supabase;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: OtterList(),
    );
  }
}

class OtterPage extends StatelessWidget {
  final Otter otter;
  OtterPage(this.otter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otter.common)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(otter.imageUrl),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Details",
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    Divider(color: Colors.black),
                    Text(otter.detail,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle1
                            ?.copyWith(color: Colors.black)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                          child: Text('Open Wikipedia',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .subtitle1
                                  ?.copyWith(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blueGrey
                                  )),
                          onTap: () => launch(otter.link)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
