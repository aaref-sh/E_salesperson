import 'package:e_salesperson/Screens/commission.dart';
import 'package:e_salesperson/Screens/register.dart';
import 'package:e_salesperson/Screens/sales.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:e_salesperson/models/globals.dart';
import 'package:flutter/material.dart';
import '../models/models.dart' as ss;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var myPages = [
    ...isAdmin
        ? [
            ss.Route('إدارة المندوبين', const Register(), Icons.person),
            ss.Route('العمولات', const Commissions(), Icons.money)
          ]
        : [],
    ss.Route('إدخال عمليات البيع', const Sales(), Icons.attach_money),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl, // set this property
        child: RoutePage(
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: myPages.length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.cyan[50],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: myPages[index].body,
                          ),
                        ),
                      );
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(myPages[index].icon),
                        Text(myPages[index].name),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          routeName: 'الرئيسية',
        ),
      ),
    );
  }
}
