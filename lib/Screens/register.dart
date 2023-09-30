import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_salesperson/Screens/loginPage.dart';
import 'package:e_salesperson/components/route.dart';
import 'package:e_salesperson/models/models.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // final ImagePicker picker = ImagePicker();

  var tfusernamecontroller = TextEditingController();
  var tfPasswordcontroller = TextEditingController();
  var tfphonecontroller = TextEditingController();
  int placeNum = 0;
  @override
  Widget build(BuildContext context) {
    return RoutePage(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                TextField(
                  controller: tfusernamecontroller,
                ),
                TextField(
                  controller: tfPasswordcontroller,
                ),
                TextField(
                  controller: tfphonecontroller,
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
                TextButton(
                  onPressed: (() {
                    createUser();
                  }),
                  child: Text("إنشاء"),
                )
              ],
            ),
          ),
        ),
        routeName: "Register");
  }

  Future createUser() async {
    final docUser = FirebaseFirestore.instance.collection('User').doc();
    var passBytes = utf8.encode(tfPasswordcontroller.text);
    getUser(tfusernamecontroller.text).then((value) => {
          if (value != null)
            {
              // throw exception username exist
            }
        });
    final user = User(
      tfusernamecontroller.text,
      sha256.convert(passBytes).toString(),
      tfphonecontroller.text,
      Place.values[placeNum],
      'imageBase64',
    );

    await docUser
        .set(user.toJson())
        .then((value) => {})
        .onError((error, stackTrace) => {});
  }
}
