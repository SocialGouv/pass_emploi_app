import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

extension GlobayKeyA11yExt on GlobalKey {
  void requestA11yFocus() {
    currentContext?.findRenderObject()?.sendSemanticsEvent(FocusSemanticEvent());
  }

  void requestFocusDelayed({Duration? duration}) {
    Future.delayed(duration ?? Duration(milliseconds: 100), () {
      currentContext?.findRenderObject()?.sendSemanticsEvent(FocusSemanticEvent());
    });
  }
}

class AutoFocusA11y extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final Duration? duration;

  const AutoFocusA11y({
    super.key,
    required this.child,
    this.enabled = true,
    this.duration,
  });

  @override
  State<AutoFocusA11y> createState() => _AutoFocusA11yState();
}

class _AutoFocusA11yState extends State<AutoFocusA11y> {
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => globalKey.requestFocusDelayed(duration: widget.duration));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: globalKey,
      child: widget.child,
    );
  }
}
