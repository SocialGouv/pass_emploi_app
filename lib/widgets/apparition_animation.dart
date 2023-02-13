import 'package:flutter/material.dart';

class ApparitionAnimation extends StatefulWidget {
  const ApparitionAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<ApparitionAnimation> createState() => _ApparitionAnimationState();
}

class _ApparitionAnimationState extends State<ApparitionAnimation> {
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
