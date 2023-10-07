import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:e_salesperson/models/globals.dart';
import 'package:e_salesperson/models/models.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  late final Future<List<User>> users;

  @override
  initState() {
    users = getUsers(context);
    users.then((value) => {if (!isAdmin) selected = value[0]});
    super.initState();
  }

  var tfeast = TextEditingController(text: '0');
  var tfwest = TextEditingController(text: '0');
  var tfnorth = TextEditingController(text: '0');
  var tfsowth = TextEditingController(text: '0');
  var tflebanon = TextEditingController(text: '0');
  var totalCommission = 0;
  DateTime selectedDate = DateTime.now();

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
                  isAdmin
                      ? SizedBox(
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
                                totalCommission = 0;
                                tfeast.text = tfwest.text = tfnorth.text =
                                    tfsowth.text = tflebanon.text = "";
                                selected = users
                                    .where((element) => element.id == x)
                                    .first;
                              });
                            },
                            value: selected?.id,
                          ),
                        )
                      : Container(),
                  selected == null
                      ? Container()
                      : Column(
                          children: [
                            renderHeader(size, context),
                            Column(
                              children: [
                                SizedBox(
                                  width: size.width,
                                  height: 220,
                                  child: renderFields(context),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.blueGrey)),
                                    onPressed: saveCommission,
                                    child: const Text("حفظ"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Column renderPage(Size size, BuildContext context) {
    return Column(
      children: [
        renderHeader(size, context),
        Column(
          children: [
            SizedBox(
              width: size.width,
              height: 220,
              child: renderFields(context),
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueGrey)),
                onPressed: saveCommission,
                child: const Text("حفظ"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding renderHeader(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Text('المنطقة: ${placeLabel[selected!.place.index]}'),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueGrey)),
                onPressed: () {
                  showMonthPicker(
                    context: context,
                    initialDate: selectedDate,
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  });
                },
                child: Text(formatDate(selectedDate)),
              ),
            ],
          )
        ],
      ),
    );
  }

  GridView renderFields(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
              labelText: 'لبنان',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green[500]!,
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
    if (es > b) {
      tc.text = b.toString();
    } else if (es == 0) {
      tc.text = '0';
    }
    es = min(es, b);
    var ec = min(es, m) * e / 100 + max(0, es - m) * (e == 5 ? 7 : 4) / 100;
    return ec.floor();
  }

  Future<void> saveCommission() async {
    var date = formatDate(selectedDate);
    showDataAlert(context, "الرجاء الانتظار", loading: true);
    var com = await getCommission(selected!.id, date);

    final doc = FirebaseFirestore.instance.collection('Commission').doc();

    final comObj = Commission(
      doc.id,
      int.tryParse(tfeast.text) ?? 0,
      int.tryParse(tfwest.text) ?? 0,
      int.tryParse(tfnorth.text) ?? 0,
      int.tryParse(tfsowth.text) ?? 0,
      int.tryParse(tflebanon.text) ?? 0,
      totalCommission,
      date,
      selected!.id,
    );
    late String msg;
    if (com != null) {
      await FirebaseFirestore.instance
          .collection('Commission')
          .doc(com.id)
          .update(comObj.toUpdateJson());
      msg = "تم تحديث السجل";
    } else {
      await doc.set(comObj.toJson());
      msg = "تم حفظ السجل";
    }
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    showDataAlert(context, msg);
  }
}

Future<List<User>> getUsers(context) async {
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
  var commissions = FirebaseFirestore.instance.collection('Commission');

  var commission = await commissions
      .where('userId', isEqualTo: userId)
      .where('date', isEqualTo: date)
      .get();

  for (var doc in commission.docs) {
    var data = doc.data();
    if (data['userId'] != null) return Commission.fromMap(data);
  }
  return null;
}
