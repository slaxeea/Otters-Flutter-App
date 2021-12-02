import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otter_library/otter_list.dart';
import 'ExperienceClass.dart';
import 'styles.dart';
import 'main.dart';
import 'experience.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String mail;
  String password;
  String error = "";

  FutureOr<void> onError(err) {
    setState(() {
      error = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const SizedBox(height: 18),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            onChanged: (String value) {
              mail = value;
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (String value) {
              password = value;
            },
          ),
          errorWidget(this.error),
          const SizedBox(height: 18),
          ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                supabase.auth
                    .signIn(email: mail, password: password)
                    .then((response) {
                  if ((response.error) != null) {
                    setState(() {
                      error = (response.error.message);
                    });
                  } else {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => experience()));
                  }
                });
              }),
        ],
      ),
    );
  }
}

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String mail;
  String password;
  String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const SizedBox(height: 18),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            onChanged: (String value) {
              mail = value;
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (String value) {
              password = value;
            },
          ),
          errorWidget(this.error),
          const SizedBox(height: 18),
          ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                supabase.auth.signUp(mail, password).then((response) {
                  if ((response.error) != null) {
                    setState(() {
                      error = (response.error.message);
                    });
                  } else {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => experience()));
                  }
                });
              }),
        ],
      ),
    );
  }
}

Widget errorWidget(String error) {
  if (error != null && error != "") {
    return (Center(
      child: Text(
        error,
        style: errorstyle,
      ),
    ));
  } else {
    return Container();
  }
}

String getUserId() {
  return supabase.auth.currentUser.id;
}
