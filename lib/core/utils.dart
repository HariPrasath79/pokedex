import 'dart:math';
import 'dart:ui';

int randomIndex() {
  Random random = Random();
  int randomNumber = random.nextInt(5);
  return randomNumber;
}

List<Color> lightColors = const [
  Color.fromRGBO(190, 220, 220, 1),
  Color.fromRGBO(196, 227, 212, 1),
  Color.fromRGBO(241, 206, 176, 1),
  Color.fromRGBO(235, 188, 180, 1),
  Color.fromRGBO(239, 211, 187, 1),
];
