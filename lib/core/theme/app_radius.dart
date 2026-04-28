import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 4;      // 0.25rem
  static const double md = 8;      // 0.5rem (DEFAULT)
  static const double lg = 12;     // 0.75rem
  static const double xl = 16;     // 1rem
  static const double xxl = 24;    // 1.5rem
  static const double full = 9999;

  static const borderSm = BorderRadius.all(Radius.circular(sm));
  static const borderMd = BorderRadius.all(Radius.circular(md));
  static const borderLg = BorderRadius.all(Radius.circular(lg));
  static const borderXl = BorderRadius.all(Radius.circular(xl));
  static const borderXxl = BorderRadius.all(Radius.circular(xxl));
  static const borderFull = BorderRadius.all(Radius.circular(full));
}
