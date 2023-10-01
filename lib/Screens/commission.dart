import 'package:e_salesperson/components/route.dart';
import 'package:flutter/material.dart';

class Commission extends StatefulWidget {
  const Commission({super.key});

  @override
  State<Commission> createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  @override
  Widget build(BuildContext context) {
    return RoutePage(
      body: Container(),
      routeName: "العمولات",
    );
  }
}
