import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage(this.jwt, this.payload, {super.key});

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("In progress"),
    );
  }
}
