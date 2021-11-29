import 'package:flutter/cupertino.dart';

class DefaultAnimatedSwitcher extends AnimatedSwitcher {
  DefaultAnimatedSwitcher({required Widget child})
      : super(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => FadeTransition(child: child, opacity: animation),
          switchInCurve: Curves.easeInOutBack,
          switchOutCurve: Curves.easeInOutBack,
          child: child,
        );
}
