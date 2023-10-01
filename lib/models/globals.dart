import 'package:e_salesperson/models/models.dart';
import 'package:flutter/material.dart';

User? me;
bool isAdmin = false;

showDataAlert(BuildContext context, String message, {bool loading = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.only(
          top: 10.0,
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(message)),
            ),
            loading
                ? Container()
                : Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("موافق"),
                    ),
                  ),
          ],
        ),
      );
    },
  );
}
