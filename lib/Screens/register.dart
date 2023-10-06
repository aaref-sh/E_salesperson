import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_salesperson/Screens/login.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:e_salesperson/models/globals.dart';
import 'package:e_salesperson/models/models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

final ImagePicker picker = ImagePicker();

class _RegisterState extends State<Register> {
  var tfusernamecontroller = TextEditingController();
  var tfPasswordcontroller = TextEditingController();
  var tfphonecontroller = TextEditingController();
  int placeNum = 0;
  Uint8List imageBytes = Uint8List(0);
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return RoutePage(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTapOutside: ((event) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: tfusernamecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'اسم المستخدم',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTapOutside: ((event) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: tfPasswordcontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'كلمة المرور',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTapOutside: ((event) {
                    FocusScope.of(context).unfocus();
                  }),
                  controller: tfphonecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'رقم الهاتف',
                  ),
                ),
              ),
              DropdownButton<int>(
                items: Place.values.map((Place value) {
                  return DropdownMenuItem<int>(
                    value: value.index,
                    child: Text(placeLabel[value.index]),
                  );
                }).toList(),
                onChanged: (x) {
                  setState(() {
                    placeNum = x ?? 0;
                  });
                },
                value: placeNum,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (() async {
                        imageBytes = Uint8List(0);
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          File imageFile = File(image!.path);
                          imageBytes = await imageFile.readAsBytes();
                        }
                        setState(() {});
                      }),
                      child: Text(image == null
                          ? "اختر صورة"
                          : image!.path.split('\\').last.split('/').last),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: ElevatedButton(
                  onPressed: (() {
                    createUser();
                  }),
                  child: const Text("إنشاء"),
                ),
              ),
            ],
          ),
        ),
      ),
      routeName: "تسجيل",
    );
  }

  Future createUser() async {
    try {
      var username = tfusernamecontroller.text;
      var phone = tfphonecontroller.text;
      var pass = tfPasswordcontroller.text;
      if ([username, phone, pass].any((element) => element == '')) {
        showDataAlert(context, "جميع الحقول مطلوبة");
        return;
      }
      showDataAlert(context, "الرجاء الانتظار", loading: true);

      final docUser = FirebaseFirestore.instance.collection('User').doc();
      var passBytes = utf8.encode(pass);

      var u = await getUser(tfusernamecontroller.text);

      if (u != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        showDataAlert(context, "اسم المستخدم محجوز");
        return;
      }
      final user = User(
        docUser.id,
        username,
        sha256.convert(passBytes).toString(),
        phone,
        Place.values[placeNum],
        imageBytes,
        formatDate(DateTime.now()),
      );

      await docUser.set(user.toJson());
      setState(() {
        tfPasswordcontroller.text = '';
        tfusernamecontroller.text = '';
        tfphonecontroller.text = '';
        imageBytes = Uint8List(0);
        image = null;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      showDataAlert(context, "تم إضافة المستخدم");
    } catch (e) {
      showDataAlert(context, e.toString());
    }
  }
}
