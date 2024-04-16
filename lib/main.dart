import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show ascii, base64, json, jsonDecode;

import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();

void main() {
  storage.deleteAll();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null || JwtDecoder.isExpired(jwt)) {
      await storage.delete(key: "jwt");
      return "";
    }
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str!.split(".");

              if (jwt.length != 3) {
                return LoginPage();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                return HomePage(str, payload);
              }
            } else {
              return LoginPage();
            }
          }),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<Map<String, dynamic>?> attemptLogIn(
      String username, String password) async {
    var res = await http.post(Uri.http("localhost:8000", "/login"),
        body: {"username": username, "password": password});
    if (res.statusCode == 200) return jsonDecode(res.body);
    return null;
  }

  Future<int> attemptSignUp(String username, String password) async {
    var res = await http.post(Uri.http("localhost:8000", "/signup"),
        body: {"username": username, "password": password});
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Log In"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    if (username.isEmpty) {
                      displayDialog(context, "Invalid Username",
                          "The username should not be empty.");
                      return;
                    }

                    var password = _passwordController.text;
                    if (password.isEmpty) {
                      displayDialog(context, "Invalid Password",
                          "The password should not be empty.");
                      return;
                    }

                    var jwt = await attemptLogIn(username, password);
                    storage.write(key: "jwt", value: jwt?["access_token"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage.fromBase64(jwt!["access_token"])));
                  },
                  child: const Text("Log In")),
              ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    if (username.length < 4)
                      displayDialog(context, "Invalid Username",
                          "The username should be at least 4 characters long");
                    else if (password.length < 4)
                      displayDialog(context, "Invalid Password",
                          "The password should be at least 4 characters long");
                    else {
                      var res = await attemptSignUp(username, password);
                      if (res == 201)
                        displayDialog(context, "Success",
                            "The user was created. Log in now.");
                      else if (res == 409)
                        displayDialog(
                            context,
                            "That username is already registered",
                            "Please try to sign up using another username or log in if you already have an account.");
                      else {
                        displayDialog(
                            context, "Error", "An unknown error occurred.");
                      }
                    }
                  },
                  child: const Text("Sign Up"))
            ],
          ),
        ));
  }
}

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) =>
      HomePage(jwt, JwtDecoder.decode(jwt));

  final String jwt;
  final Map<String, dynamic> payload;

  Future<Map<String, dynamic>> get userData async {
    var res = await http.get(Uri.http("localhost:8000", "/userdata"),
        headers: {"Authorization": "Bearer $jwt"});
    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    print(payload);
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome back ${payload["sub"]}"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await storage.delete(key: "jwt");
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: "My Battles"),
          BottomNavigationBarItem(icon: Icon(Icons.replay), label: "Replays"),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: "Stats")
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReplayPage(jwt, payload)));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StatsPage(jwt, payload)));
              break;
            default:
              break;
          }
        },
      ),
      body: Center(
          child: FutureBuilder(
              future: userData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                if (snapshot.data != "") {
                  List<dynamic> replays = snapshot.data!["replays"];
                  return ListView.builder(
                      itemCount: replays.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(replays[index]["uploaded_by"].toString()),
                          subtitle:
                              Text(replays[index]["session_id"].toString()),
                        );
                      });
                } else {
                  return LoginPage();
                }
              })),
    );
  }
}
