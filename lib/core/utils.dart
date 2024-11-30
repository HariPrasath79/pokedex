import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

int randomIndex() {
  Random random = Random();
  int randomNumber = random.nextInt(5);
  return randomNumber;
}

String getIndexofPokemon(int index) {
  if (index < 10) {
    return "00$index";
  } else if (index >= 10 && index <= 99) {
    return "0$index";
  } else {
    return "$index";
  }
}

List<Color> lightColors = const [
  Color.fromRGBO(190, 220, 220, 1),
  Color.fromRGBO(196, 227, 212, 1),
  Color.fromRGBO(241, 206, 176, 1),
  Color.fromRGBO(235, 188, 180, 1),
  Color.fromRGBO(239, 211, 187, 1),
];

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> getSnackBar(
    BuildContext context,
    {required String hint}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(hint),
    margin: const EdgeInsets.all(20),
    behavior: SnackBarBehavior.floating,
  ));
}
