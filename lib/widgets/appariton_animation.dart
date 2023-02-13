import 'package:flutter/material.dart';

class ApparitonAnimation extends StatefulWidget {
  const ApparitonAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<ApparitonAnimation> createState() => _ApparitonAnimationState();
}

class _ApparitonAnimationState extends State<ApparitonAnimation> {
  bool animationStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      setState(() {
        animationStarted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: animationStarted ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      sizeCurve: Curves.ease,
      duration: const Duration(milliseconds: 300),
      firstChild: SizedBox.shrink(),
      secondChild: widget.child,
    );
  }
}
