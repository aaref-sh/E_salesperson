import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:e_salesperson/models/globals.dart';
import 'package:e_salesperson/models/models.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  late final Future<List<User>> users;

  @override
  initState() {
    users = getUsers();
    super.initState();
  }

  var tfeast = TextEditingController(text: '0');
  var tfwest = TextEditingController(text: '0');
  var tfnorth = TextEditingController(text: '0');
  var tfsowth = TextEditingController(text: '0');
  var tflebanon = TextEditingController(text: '0');
  var totalCommission = 0;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  User? selected;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RoutePage(
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            var users = snapshot.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    child: DropdownButton<String>(
                      hint: Row(
                        children: const [
                          Icon(Icons.person_outline),
                          Text('اختر المندوب'),
                        ],
                      ),
                      items: users!.map((user) {
                        return DropdownMenuItem<String>(
                          value: user.id,
                          child: Text(user.username),
                        );
                      }).toList(),
                      onChanged: (x) {
                        setState(() {
                          selected =
                              users.where((element) => element.id == x).first;
                        });
                      },
                      value: selected?.id,
                    ),
                  ),
                  selected == null
                      ? Container()
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.memory(
                                      selected!.imageBytes,
                                      width: size.width / 2 - 15,
                                      height: size.width / 2 - 15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const Text('منطقة المندوب:'),
                                      Text(placeLabel[selected!.place.index]),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(DateFormat('yyyy-MM')
                                              .format(selectedDate)),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              showMonthPicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                              ).then((date) {
                                                if (date != null) {
                                                  setState(() {
                                                    selectedDate = date;
                                                  });
                                                }
                                              });
                                            },
                                            child: Icon(Icons.calendar_today),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: size.width,
                                  height: 220,
                                  child: GridView(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 2.5,
                                      //    crossAxisSpacing: 20,
                                      // mainAxisSpacing: 20,
                                    ),
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          onTapOutside: ((event) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          onChanged: calculateCommission,
                                          controller: tfeast,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'المنطقة الشرقية',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          onTapOutside: ((event) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          onChanged: calculateCommission,
                                          controller: tfwest,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'المنطقة الساحلية',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          onTapOutside: ((event) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          onChanged: calculateCommission,
                                          controller: tfnorth,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'المنطقة الشمالية',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          onTapOutside: ((event) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          keyboardType: TextInputType.number,
                                          onChanged: calculateCommission,
                                          controller: tfsowth,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'المنطقة الجنوبية',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          onTapOutside: ((event) {
                                            FocusScope.of(context).unfocus();
                                          }),
                                          keyboardType: TextInputType.number,
                                          onChanged: calculateCommission,
                                          controller: tflebanon,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'المنطقة لبنان',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red[500]!,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'العمولة الكلية: $totalCommission',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: saveCommission,
                                    child: const Text("حفظ"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: users,
      ),
      routeName: "عمليات البيع",
    );
  }

  void calculateCommission(String value) {
    var ec = fixValue(tfeast, Place.east);
    var wc = fixValue(tfwest, Place.west);
    var nc = fixValue(tfnorth, Place.north);
    var sc = fixValue(tfsowth, Place.sowth);
    var lc = fixValue(tflebanon, Place.lebanon);

    setState(() {
      totalCommission = ec + wc + nc + sc + lc;
    });
  }

  static const m = 1000000;
  static const b = 1000000000; // max value

  int fixValue(TextEditingController tc, Place p) {
    var e = selected!.place == p ? 5 : 3;
    var es = int.tryParse(tc.text) ?? 0;
    if (es > b)
      tc.text = b.toString();
    else if (es == 0) tc.text = '0';
    es = min(es, b);
    var ec = min(es, m) * e / 100 + max(0, es - m) * (e == 5 ? 7 : 4) / 100;
    return ec.floor();
  }

  Future<void> saveCommission() async {
    var date = DateFormat('yyyy-MM').format(selectedDate);
    showDataAlert(context, "الرجاء الانتظار", loading: true);
    var com;
    try {
      com = await getCommission(selected!.id, date);
    } catch (e) {}
    final doc = FirebaseFirestore.instance.collection('Commission').doc();

    final comObj = Commission(
        doc.id,
        int.parse(tfeast.text),
        int.parse(tfwest.text),
        int.parse(tfnorth.text),
        int.parse(tfsowth.text),
        int.parse(tflebanon.text),
        totalCommission,
        date,
        selected!.id);

    if (com != null) {
      await FirebaseFirestore.instance
          .collection('Commission')
          .doc(com.id)
          .update(comObj.toUpdateJson());
      Navigator.of(context).pop();
      showDataAlert(context, "تم تحديث السجل");
    } else {
      await doc.set(comObj.toJson());
      Navigator.of(context).pop();
      showDataAlert(context, "تم حفظ السجل");
    }
  }
}

Future<List<User>> getUsers() async {
  if (!isAdmin) return [me!];

  var users = await FirebaseFirestore.instance.collection('User').get();

  List<User> s = <User>[];
  for (var doc in users.docs) {
    var data = doc.data();
    if (data['Password'] != '') {
      var admin = data.containsKey('IsAdmin') && data['IsAdmin'] as bool;
      if (!admin) s.add(User.fromMap(data));
    }
  }
  return s;
}

Future<Commission?> getCommission(String userId, String date) async {
  CollectionReference commissions =
      FirebaseFirestore.instance.collection('Commission');

  QuerySnapshot commission = await commissions
      .where('userId', isEqualTo: userId)
      .where('date', isEqualTo: date)
      .get();

  for (var doc in commission.docs) {
    var data = doc.data() as Map<String, dynamic>;
    if (data['userId'] != null) {
      return Commission.fromMap(data);
    }
  }
  return null;
}
