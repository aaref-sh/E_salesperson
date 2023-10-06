import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:e_salesperson/Screens/home.dart';
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
    if (username == '' || pass == '') {
      showDataAlert(context, "جميع الحقول مطلوبة");
      return;
    }
    showDataAlert(context, "الرجاء الانتظار", loading: true);
    var passBytes = utf8.encode(pass);
    var user = await getUser(username, login: true);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    if (user == null || user.password != sha256.convert(passBytes).toString()) {
      // ignore: use_build_context_synchronously
      showDataAlert(context, "خطأ في اسم المستخدم أو كلمة المرور");
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  void initState() {
    tfusername.text = 'admin';
    tfpassword.text = 'admin';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoutePage(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onTapOutside: ((event) {
                      FocusScope.of(context).unfocus();
                    }),
                    controller: tfusername,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'اسم المستخدم',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  child: TextField(
                    onTapOutside: ((event) {
                      FocusScope.of(context).unfocus();
                    }),
                    controller: tfpassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'كلمة المرور',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: tryLogin,
                  child: const Text("تسجيل الدخول"),
                ),
              ],
            ),
          ),
        ),
      ),
      routeName: "تسجيل الدخول",
    );
  }
}

Future<User?> getUser(String username, {bool login = false}) async {
  CollectionReference users = FirebaseFirestore.instance.collection('User');

  QuerySnapshot querySnapshot =
      await users.where('Username', isEqualTo: username).get();
  User? s;
  me = login ? null : me;
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    if (data['Password'] != '') {
      isAdmin = data.containsKey('IsAdmin') && data['IsAdmin'] as bool;
      s = User.fromMap(data);
      me = login ? s : me;
      break;
    }
  }
  return s;
}
