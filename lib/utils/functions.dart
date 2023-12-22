import 'dart:ui';

import 'type_colors.dart';

String changeNumberToThreeDigits(int number) {
  String numberString = "";
  if (number < 10) {
    numberString = "00$number";
  } else if (number < 100) {
    numberString = "0$number";
  } else {
    numberString = number.toString();
  }
  return numberString;
}

Color getBackgroundColor(String type) {
  switch (type) {
    case "dark":
      return colorDark;
    case "dragon":
      return colorDragon;
    case "electric":
      return colorElectric;
    case "fairy":
      return colorFairy;
    case "fighting":
      return colorFighting;
    case "fire":
      return colorFire;
    case "flying":
      return colorFlying;
    case "ghost":
      return colorGhost;
    case "grass":
      return colorGrass;
    case "ground":
      return colorGround;
    case "ice":
      return colorIce;
    case "normal":
      return colorNormal;
    case "poison":
      return colorPoison;
    case "psychic":
      return colorPsychic;
    case "rock":
      return colorRock;
    case "steel":
      return colorSteel;
    case "water":
      return colorWater;
    case "bug":
      return colorBug;
    default:
      return colorNormal;
  }
}
