import 'package:e_salesperson/Screens/mainPage.dart';
import 'package:e_salesperson/Screens/register.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'Screens/loginPage.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (context, state) {
          return const Login();
        },
        routes: [
          GoRoute(
            path: 'Home',
            builder: (context, state) {
              return const MainPage();
            },
            routes: <RouteBase>[
              GoRoute(
                  path: 'Register',
                  builder: (context, state) {
                    return const Register();
                  })
            ],
          ),
        ])
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}
