import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  void alert(String errorMsg, {String? type = "error"}) {
    Fluttertoast.showToast(
        msg: errorMsg,
        gravity: ToastGravity.TOP,
        backgroundColor: type == "error"
            ? Colors.redAccent.shade100
            : const Color(0xFFD4A7FB),
        fontSize: 14,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT);
  }
}
