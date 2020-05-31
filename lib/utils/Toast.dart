import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

myToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.white70,
      textColor: Colors.black,
      fontSize: 16.0
    );
}