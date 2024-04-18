import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show jsonDecode;

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wtstatsgagaaapp/login_page.dart';
import 'package:wtstatsgagaaapp/main.dart';
import 'package:wtstatsgagaaapp/replays_page.dart';
import 'package:wtstatsgagaaapp/stats_page.dart';

const storage = FlutterSecureStorage();

class BattlesHistoryPage extends StatefulWidget {
  BattlesHistoryPage(this.jwt, this.payload);

  factory BattlesHistoryPage.fromBase64(String jwt) =>
      BattlesHistoryPage(jwt, JwtDecoder.decode(jwt));
  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _BattlesHistoryPageState createState() => _BattlesHistoryPageState();
}

class _BattlesHistoryPageState extends State<BattlesHistoryPage> {
  Future<Map<String, dynamic>>? _userData;

  @override
  void initState() {
    super.initState();
    _userData = userData;
  }

  Future<Map<String, dynamic>> get userData async {
    var res = await http.get(Uri.http("localhost:8000", "/userdata"),
        headers: {"Authorization": "Bearer ${widget.jwt}"});
    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("In progress"),
    );
  }
}
