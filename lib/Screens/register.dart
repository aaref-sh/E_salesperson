import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_salesperson/Screens/login.dart';
import 'package:e_salesperson/Screens/sales.dart';
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
  late Future<List<User>> users;
  List<User> allUsers = <User>[];
  User? updateUser;
  @override
  void initState() {
    users = getUsers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoutePage(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
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
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
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
                    keyboardType: TextInputType.phone,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
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
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blueGrey)),
                          onPressed: (() async {
                            imageBytes = Uint8List(0);
                            image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              File imageFile = File(image!.path);
                              imageBytes = await imageFile.readAsBytes();
                            }
                            setState(() {});
                          }),
                          child: Text(
                            image == null
                                ? "اختر صورة"
                                : fileName(image!.path).substring(
                                    max(0, fileName(image!.path).length - 20)),
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                    imageBytes.isNotEmpty
                        ? ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Image.memory(
                              imageBytes,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person_outline_sharp,
                            size: 80,
                          )
                  ],
                ),
                updateUser == null
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blueGrey)),
                          onPressed: () => createUser(),
                          child: const Text("إنشاء"),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              onPressed: () => userUpdate(context),
                              child: const Text("تحديث"),
                            ),
                          ),
                          Expanded(child: Container()),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.black54, // Background color
                              ),
                              onPressed: (() {
                                setState(() {
                                  clearFields();
                                  updateUser = null;
                                });
                              }),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Text("إلغاء"),
                                  Icon(Icons.cancel),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                Expanded(child: usersList())
              ],
            ),
          ),
        ),
      ),
      routeName: "المندوبين",
    );
  }

  String fileName(path) {
    return image!.path.split('\\').last.split('/').last;
  }

  Widget usersList() {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          allUsers = allUsers.isEmpty ? snapshot.data! : allUsers;
          return ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                    leading: Image.memory(
                      allUsers[i].imageBytes,
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () => setUserUpdate(allUsers[i]),
                            icon: const Icon(
                              Icons.mode_edit_outlined,
                              weight: 40,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                deleteConfirmation(allUsers[i], context),
                            icon: const Icon(
                              Icons.delete_forever,
                              weight: 40,
                              color: Color.fromARGB(255, 100, 25, 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(allUsers[i].username));
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: users,
    );
  }

  Future<void> createUser() async {
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
      pass = getPassHash(pass);

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
        pass,
        phone,
        Place.values[placeNum],
        imageBytes,
        formatDate(DateTime.now()),
      );

      await docUser.set(user.toJson());
      setState(() {
        allUsers.add(user);
        clearFields();
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      showDataAlert(context, "تم إضافة المستخدم");
    } catch (e) {
      showDataAlert(context, e.toString());
    }
  }

  String getPassHash(String pass) {
    var passBytes = utf8.encode(pass);
    return sha256.convert(passBytes).toString();
  }

  void clearFields() {
    tfPasswordcontroller.text = '';
    tfusernamecontroller.text = '';
    tfphonecontroller.text = '';
    imageBytes = Uint8List(0);
    placeNum = 0;
    image = null;
  }

  deleteConfirmation(User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: const Text('سيتكم الحذف بشكل دائم ونهائي'),
          actions: <Widget>[
            TextButton(
              child: const Text('موافق'),
              onPressed: () {
                // Perform the desired action
                Navigator.of(context).pop();
                deleteUser(user, context);
              },
            ),
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser(User user, BuildContext context) async {
    showDataAlert(context, "الرجاء الانتظار", loading: true);
    var collection = FirebaseFirestore.instance.collection('User');
    var msg = "تم حذف المستخدم";
    try {
      await collection.doc(user.id).delete();
      if (!allUsers.remove(user)) throw Exception("");
    } catch (e) {
      msg = "فشل حذف المستخدم";
    } finally {
      Navigator.of(context).pop();
      showDataAlert(context, msg);
    }
    setState(() {});
  }

  setUserUpdate(User user) {
    setState(() {
      updateUser = user;
      tfphonecontroller.text = user.phoneNumber;
      tfusernamecontroller.text = user.username;
      imageBytes = user.imageBytes;
      placeNum = user.place.index;
    });
  }

  userUpdate(context) async {
    showDataAlert(context, "الرجاء الانتظار", loading: true);
    var msg = '';
    try {
      var pass = updateUser!.password;
      if (tfPasswordcontroller.text.isNotEmpty) {
        pass = getPassHash(pass);
      }
      User u = User(
          updateUser!.id,
          tfusernamecontroller.text,
          pass,
          tfphonecontroller.text,
          Place.values[placeNum],
          imageBytes,
          updateUser!.joinDate);
      await FirebaseFirestore.instance
          .collection('User')
          .doc(updateUser!.id)
          .update(u.toJson());
      allUsers = allUsers.where((x) => x.id != u.id).toList();
      setState(() {
        updateUser = null;
        allUsers.add(u);
        clearFields();
      });
      msg = "تم تحديث معلومات المندوب";
    } catch (e) {
      msg = e.toString();
    }
    Navigator.of(context).pop();
    showDataAlert(context, msg);
  }
}
