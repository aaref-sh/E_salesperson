import 'package:e_salesperson/Screens/mainPage.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController tfusername = TextEditingController();
  TextEditingController tfpassword = TextEditingController();
  void tryLogin() {
    String username = tfusername.text.trim();
    String pass = tfpassword.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoutePage(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
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
      routeName: "Login",
    );
  }
}
