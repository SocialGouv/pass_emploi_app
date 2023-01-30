import 'package:flutter/cupertino.dart';

class DefaultAnimatedSwitcher extends AnimatedSwitcher {
  DefaultAnimatedSwitcher({required Widget child})
      : super(
          duration: const Duration(milliseconds: 2000),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          switchInCurve: Curves.easeInOutBack,
          switchOutCurve: Curves.easeInOutBack,
          child: child,
        );
}
