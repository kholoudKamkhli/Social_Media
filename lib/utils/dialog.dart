
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class dialogUtilites {
  static BuildContext? dialogContext;

  static void lodingDialog(BuildContext context, String msg) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  msg,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  width: 15,
                ),
                const CircularProgressIndicator(
                  color: Colors.green,
                ),
              ],
            )),
          );
        });
  }

  static void showmsg(BuildContext context, String msg,
      {String pos = 'ok', VoidCallback? postAction, String? txt}) {
    showDialog(
      context: context,
      builder: (BuildContext buildcontext) {
        return AlertDialog(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          content: SingleChildScrollView(
              child: Text(
            msg,
            style: const TextStyle(color: Colors.black),
          )),
          actions: [
            TextButton(
              child: Text(
                pos,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
                //   postAction?.call();
              },
            ),
            if (txt != null)
              TextButton(
                child: Text(
                  txt,
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }

  static Future<void> AddDialog(BuildContext context) async {
    PlatformFile? file;


}
}
