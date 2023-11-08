import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  void signUpToast(String errorMsg) {
    Fluttertoast.showToast(
        msg: errorMsg,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent.shade100,
        fontSize: 14,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT);
  }
}
