import 'dart:convert';

import 'package:e_salesperson/models/globals.dart';
import 'package:flutter/material.dart';

class RoutePage extends StatefulWidget {
  final Widget body;
  final String routeName;
  const RoutePage({super.key, required this.body, required this.routeName});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routeName),
        backgroundColor: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 250, 8, 0),
              child: Image.memory(
                base64.decode(bgBase64),
                opacity: const AlwaysStoppedAnimation(0.2),
              )),
          widget.body,
        ],
      ),
    );
  }
}
