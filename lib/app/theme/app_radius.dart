import 'package:flutter/material.dart';

class AppRadius {
  static const double sm = 12.0;
  static const double md = 18.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double pill = 999.0;

  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusPill =
      BorderRadius.all(Radius.circular(pill));
}
