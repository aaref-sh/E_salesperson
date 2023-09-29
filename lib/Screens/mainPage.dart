import 'package:e_salesperson/Screens/register.dart';
import 'package:flutter/material.dart';
import '../models/models.dart' as ss;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// shit
class _MainPageState extends State<MainPage> {
  var myPages = [
    ss.Route('Register', const Register()),
    ss.Route('Register', const Register()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: myPages.length,
          itemBuilder: (BuildContext ctx, index) {
            return TextButton(
              onPressed: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => myPages[index].body),
                );
              }),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(myPages[index].name),
              ),
            );
          },
        ),
      ),
    );
  }
}
