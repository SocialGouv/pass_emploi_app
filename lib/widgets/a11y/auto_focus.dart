import 'package:flutter/material.dart';

class AutoFocus extends StatefulWidget {
  const AutoFocus({super.key, required this.child});
  final Widget child;

  @override
  State<AutoFocus> createState() => _AutoFocusState();
}

class _AutoFocusState extends State<AutoFocus> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
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
      focusNode: _focusNode,
      child: widget.child,
    );
  }
}
