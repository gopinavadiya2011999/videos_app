import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
//Long bottom toast
void showBottomLongToast(String value) {
  Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
}

Future<void> dismissKeyboard(BuildContext context) async =>
    FocusScope.of(context).unfocus();
