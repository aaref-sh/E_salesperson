import 'package:e_salesperson/components/route.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    var tfusernamecontroller = TextEditingController();
    TextEditingController tfphonecontroller = TextEditingController();

    return RoutePage(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              TextField(
                controller: tfusernamecontroller,
              ),
              TextField(
                controller: tfphonecontroller,
              ),
            ],
          ),
        ),
        routeName: "Register");
  }
}
