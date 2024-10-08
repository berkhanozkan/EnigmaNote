import 'dart:math';

import 'package:flutter/material.dart';

double estimateBruteforceStrength(String password) {
  if (password.isEmpty) return 0.0;

  double charsetBonus;
  if (RegExp(r'^[a-z]*$').hasMatch(password)) {
    charsetBonus = 1.0;
  } else if (RegExp(r'^[a-z0-9]*$').hasMatch(password)) {
    charsetBonus = 1.2;
  } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {
    charsetBonus = 1.3;
  } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
    charsetBonus = 1.3;
  } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
    charsetBonus = 1.5;
  } else {
    charsetBonus = 1.8;
  }

  logisticFunction(double x) {
    return 1.0 / (1.0 + exp(-x));
  }

  curve(double x) {
    debugPrint("logistic func değer! : ${(x / 3.0) - 4.0}");
    debugPrint("double x değer : $x");
    return logisticFunction((x / 3.0) - 4.0);
  }

  return curve(password.length * charsetBonus);
}
