import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:e_salesperson/Screens/mainPage.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:e_salesperson/models/globals.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController tfusername = TextEditingController();
  TextEditingController tfpassword = TextEditingController();
  Future<void> tryLogin() async {
    String username = tfusername.text.trim();
    String pass = tfpassword.text.trim();
    var passBytes = utf8.encode(pass);
    var user = await getUser(username);
    if (user == null) {
    } else if (user.password != sha256.convert(passBytes).toString()) {
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoutePage(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: tfusername,
              ),
              TextField(
                controller: tfpassword,
              ),
              TextButton(
                onPressed: tryLogin,
                child: const Text("تسجيل الدخول"),
              ),
              Text(
                '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      routeName: "تسجيل الدخول",
    );
  }
}

Future<User?> getUser(String username) async {
  CollectionReference users = FirebaseFirestore.instance.collection('User');

  QuerySnapshot querySnapshot =
      await users.where('Username', isEqualTo: username).get();
  User? s;

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['Password'] != '') {
      s = User.fromMap(data);
      isAdmin = data.containsKey('IsAdmin') && data['IsAdmin'] as bool;
      break;
    }
  }
  return s;
}
