import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wtstatsgagaaapp/page_selector.dart';

const storage = FlutterSecureStorage();

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

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
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }));
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
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
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
                    if (jwt?["access_token"] == null) {
                      displayDialog(context, "An Error Occurred",
                          "No account was found matching that username and password.");
                      return;
                    }
                    storage.write(key: "jwt", value: jwt?["access_token"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageSelector(
                                jwt?["access_token"],
                                JwtDecoder.decode(jwt?["access_token"]))));
                  },
                  child: Text('Log In'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    if (username.length < 4) {
                      displayDialog(context, "Invalid Username",
                          "The username should be at least 4 characters long");
                    } else if (password.length < 4) {
                      displayDialog(context, "Invalid Password",
                          "The password should be at least 4 characters long");
                    } else {
                      var res = await attemptSignUp(username, password);
                      if (res == 200) {
                        displayDialog(context, "Success",
                            "Congratulations! Your account has been successfully created. You can now log in.");
                      } else if (res == 409) {
                        displayDialog(context, "Username Already Registered",
                            "The username you've chosen is already in use. Please try signing up with a different username, or if you already have an account, you can log in.");
                      } else {
                        displayDialog(context, "Unexpected Error",
                            "Oops! Something went wrong. Please try again later.");
                      }
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
