import 'package:flutter/widgets.dart';

abstract final class AppRadii {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));

  static const BorderRadius lgTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );

  static const StadiumBorder stadium = StadiumBorder();
}
