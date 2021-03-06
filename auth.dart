import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'styles.dart';
import 'main.dart';
import 'experience.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Login widget
class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String mail;
  String password;
  String error = "";
  String storedMail;
  bool saveData = false;

  // get mail if one was saved in the shared preferences
  getStoredMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _res = prefs.getString("email");
    setState(() {
      storedMail = _res;
      storedMail != null ? mail = storedMail : mail = mail;
    });
  }

  @override
  Widget build(BuildContext context) {
    getStoredMail();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const SizedBox(height: 18),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            initialValue: storedMail,
            key: Key("mailinput"),
            onChanged: (String value) {
              mail = value;
            },
          ),
          TextFormField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            key: Key("pwinput"),
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (String value) {
              password = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: saveData,
                    onChanged: (bool value) {
                      setState(() {
                        saveData = value;
                      });
                    },
                  ),
                  Text("Save email for later"),
                ]),
          ),
          errorWidget(this.error),
          const SizedBox(height: 18),
          ElevatedButton(
            key: Key("loginbtn"),
              child: Text('Login'),
              onPressed: () {
                if (mail != null &&
                    mail.isNotEmpty &&
                    password != null &&
                    password.isNotEmpty &&
                    // check if mail is valid
                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(mail)) {
                  supabase.auth
                      .signIn(email: mail, password: password)
                      .then((response) {
                    if ((response.error) != null) {
                      setState(() {
                        error = (response.error.message);
                      });
                    } else {
                      if (saveData) {
                        setStoredMail(mail);
                      }
                      // return the user to the experiences tab
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => experience()));
                    }
                  });
                } else {
                  error = (mail == null || mail.isEmpty)
                      ? "Please enter a mail adress"
                      : (password == null || password.isEmpty)
                          ? "Please enter a password"
                          : "Please enter valid credentials";
                }
              }),
        ],
      ),
    );
  }
}

// Signup widget
class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String mail;
  String password;
  String error;
  bool saveData = false;

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: saveData,
                    onChanged: (bool value) {
                      setState(() {
                        saveData = value;
                      });
                    },
                  ),
                  Text("Save email for later"),
                ]),
          ),
          errorWidget(this.error),
          const SizedBox(height: 18),
          ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                if (mail != null &&
                    mail.isNotEmpty &&
                    password != null &&
                    password.isNotEmpty) {
                  supabase.auth.signUp(mail, password).then((response) {
                    if ((response.error) != null) {
                      setState(() {
                        error = (response.error.message);
                      });
                    } else {
                      if (saveData) {
                        setStoredMail(mail);
                      }
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => experience()));
                    }
                  });
                } else {
                  error = (mail == null || mail.isEmpty)
                      ? "Please enter a mail adress"
                      : (password == null || password.isEmpty)
                          ? "Please enter a password"
                          : "Please enter valid credentials";
                }
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

// save the mail provided into the preferences
void setStoredMail(String mail) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("email", mail);
}
