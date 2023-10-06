import 'package:e_salesperson/Screens/sales.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:e_salesperson/models/globals.dart';
import 'package:e_salesperson/models/models.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Commissions extends StatefulWidget {
  const Commissions({super.key});

  @override
  State<Commissions> createState() => _CommissionsState();
}

class _CommissionsState extends State<Commissions> {
  late final Future<List<User>> users;

  bool showGrid = false;

  TextEditingController tfeast = TextEditingController();
  TextEditingController tfwest = TextEditingController();
  TextEditingController tfnorth = TextEditingController();
  TextEditingController tfsowth = TextEditingController();
  TextEditingController tflebanon = TextEditingController();

  @override
  initState() {
    users = getUsers(context);
    super.initState();
  }

  DateTime? selectedDate;
  Commission? commission;
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
                          selectedDate = null;
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
                            renderHeader(size, context),
                            renderBody(),
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
      routeName: "العمولات",
    );
  }

  Widget renderBody() => selectedDate == null
      ? const Center(
          child: Text("حدد تاريخ لعرض المبيعات"),
        )
      : renderFields();

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
              const Text('منطقة المندوب:'),
              Text(placeLabel[selected!.place.index]),
              ElevatedButton(
                onPressed: () {
                  showMonthPicker(
                    context: context,
                    initialDate: selectedDate,
                  ).then((date) async {
                    setState(() {
                      selectedDate = date;
                      tfeast.text = tfwest.text =
                          tfnorth.text = tfsowth.text = tflebanon.text = '';
                      commission = null;
                    });
                    if (date != null) {
                      commission = await getSales(selected!.id, date);
                      setState(() {
                        tfeast.text = commission!.esats.toString();
                        tfwest.text = commission!.wests.toString();
                        tfnorth.text = commission!.norths.toString();
                        tfsowth.text = commission!.sowths.toString();
                        tflebanon.text = commission!.lebanons.toString();
                      });
                    }
                  });
                },
                child: selectedDate == null
                    ? const Icon(Icons.calendar_today)
                    : Text(DateFormat('yyyy-MM').format(selectedDate!)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget renderFields() {
    return commission == null
        ? const Center(
            child: Text('لا يوجد بيانات لهذا الشهر'),
          )
        : SizedBox(
            height: 220,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2.5,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
                    controller: tfsowth,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'المنطقة الجنوبية',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    controller: tflebanon,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'المنطقة لبنان',
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
                    'العمولة الكلية: ${commission!.commissions}',
                  ),
                ),
              ],
            ),
          );
  }

  Future<Commission?> getSales(String userId, DateTime date) async {
    showDataAlert(context, "الرجاء الانتظار", loading: true);
    var x = await getCommission(userId, formatDate(date));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    return x;
  }
}
