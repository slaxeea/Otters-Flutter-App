import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      body: Column(
        children: [
          Image.network(otter.imageUrl),
          Text("Details",
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline6
                  ?.copyWith(color: Colors.black)),
          Text(otter.detail,
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  ?.copyWith(color: Colors.black)),
        ],
      ),
    );
  }
}
