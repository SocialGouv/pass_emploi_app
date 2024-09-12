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

class AutoFocus extends StatefulWidget {
  const AutoFocus({super.key, required this.child});
  final Widget child;

  @override
  State<AutoFocus> createState() => _AutoFocusState();
}

class _AutoFocusState extends State<AutoFocus> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      globalKey.requestA11yFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      key: globalKey,
      focusNode: _focusNode,
      child: widget.child,
    );
  }
}
