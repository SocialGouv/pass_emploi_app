import 'package:flutter/cupertino.dart';

class Keyboard {
  Keyboard._();

  static void dismiss(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
