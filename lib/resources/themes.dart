import 'package:flutter/material.dart';

class CustomColorTheme {
  static Theme buildWhiteTheme(BuildContext context, Widget child) {
    return Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white), child: child);
  }
}
