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
            ss.Route(
              'إدارة المندوبين',
              const Register(),
              Icons.people_alt_outlined,
            ),
            ss.Route(
              'العمولات',
              const Commissions(),
              Icons.money,
            )
          ]
        : <ss.Route>[],
    ss.Route(
      'إدخال عمليات البيع',
      const Sales(),
      Icons.attach_money,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return RoutePage(
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
                  color: Color.fromARGB(66, 129, 160, 175),
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
                    Icon(
                      myPages[index].icon,
                      color: Color.fromARGB(255, 105, 105, 105),
                      size: 35,
                    ),
                    Text(myPages[index].name,
                        style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      routeName: 'الرئيسية',
    );
  }
}
