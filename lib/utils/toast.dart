import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haedal/styles/colors.dart';

class CustomToast {
  void alert(String errorMsg, {String? type = "error"}) {
    Fluttertoast.showToast(
        msg: errorMsg,
        gravity: ToastGravity.TOP,
        backgroundColor:
            type == "error" ? Colors.redAccent.shade100 : AppColors().mainColor,
        fontSize: 14,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT);
  }
}
