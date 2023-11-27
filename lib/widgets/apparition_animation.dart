import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';

class ApparitionAnimation extends StatefulWidget {
  final Widget child;

  const ApparitionAnimation({super.key, required this.child});

  @override
  State<ApparitionAnimation> createState() => _ApparitionAnimationState();
}

class _ApparitionAnimationState extends State<ApparitionAnimation> {
  bool animationStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      setState(() => animationStarted = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: animationStarted ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      sizeCurve: Curves.ease,
      duration: AnimationDurations.medium,
      firstChild: SizedBox.shrink(),
      secondChild: widget.child,
    );
  }
}
