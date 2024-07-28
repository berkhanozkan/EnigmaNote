import 'package:flutter/widgets.dart';

class SystemConstants {
  static const APP_TITLE = "Enigma Note";
  static const HIVE_BOXNAME = "notesCache";
  static const TRANSLATIONS = "assets/translations";
}

class SystemPadding extends EdgeInsets {
  const SystemPadding.onlyTop() : super.only(top: 20);
  const SystemPadding.onlyVerticalSymmetric() : super.symmetric(vertical: 10);
  const SystemPadding.onlyMiniTop() : super.only(top: 10);
  const SystemPadding.all() : super.all(20);
  const SystemPadding.miniAll() : super.all(10);
}
