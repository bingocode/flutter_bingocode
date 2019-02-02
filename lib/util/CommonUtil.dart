import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonUtil {
  static toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }

}