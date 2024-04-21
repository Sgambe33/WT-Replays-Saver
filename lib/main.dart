import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show ascii, base64, json;

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wtreplaysaver/pages/login_page.dart';
import 'package:wtreplaysaver/pages/page_selector.dart';

const storage = FlutterSecureStorage();

void main() {
  storage.deleteAll();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      theme: ThemeData.dark(),
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
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                return PageSelector(str, payload);
              }
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
