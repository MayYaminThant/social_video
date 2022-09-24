import 'package:flutter/material.dart';

class CommonUtils {
  static void doInFuture(VoidCallback callback) {
    Future.delayed(Duration.zero, callback);
  }
}
