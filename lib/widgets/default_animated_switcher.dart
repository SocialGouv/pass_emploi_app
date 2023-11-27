import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';

class DefaultAnimatedSwitcher extends AnimatedSwitcher {
  DefaultAnimatedSwitcher({required Widget child})
      : super(
    duration: AnimationDurations.slow,
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
          switchInCurve: Curves.easeInOutBack,
          switchOutCurve: Curves.easeInOutBack,
          child: child,
        );
}
