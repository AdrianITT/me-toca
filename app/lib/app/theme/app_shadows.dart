import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Only two shadows exist. Dark mode replaces them with a 1px border.
abstract final class AppShadows {
  static List<BoxShadow> of(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return const [];
    }
    return sm;
  }

  static const sm = [
    BoxShadow(color: Color(0x0F1E2A24), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const md = [
    BoxShadow(color: Color(0x141E2A24), blurRadius: 24, offset: Offset(0, 8)),
  ];
}

/// Border used in dark mode instead of shadows.
BorderSide appHairline(BuildContext context) =>
    BorderSide(color: context.palette.border);
