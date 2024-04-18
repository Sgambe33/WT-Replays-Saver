import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show ascii, base64, json, jsonDecode;

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wtstatsgagaaapp/battles_history_page.dart';
import 'package:wtstatsgagaaapp/login_page.dart';
import 'package:wtstatsgagaaapp/page_selector.dart';
import 'package:wtstatsgagaaapp/replays_page.dart';
import 'package:wtstatsgagaaapp/stats_page.dart';

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
                return PageSelector(str, payload);
              }
            } else {
              return LoginPage();
            }
          }),
    );
  }
}
