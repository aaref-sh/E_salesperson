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
      ),
      body: SingleChildScrollView(
        child: widget.body,
      ),
    );
  }
}
