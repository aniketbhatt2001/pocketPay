import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  /// Level 1 — Cards / Surfaces
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x0A000000), // rgba(0,0,0,0.04)
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  /// Level 2 — Floating / Interactive (buttons, bottom sheets)
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x1F1A237E), // rgba(26,35,126,0.12)
      blurRadius: 30,
      offset: Offset(0, 8),
    ),
  ];
}
