import 'dart:async';

import 'package:flutter/material.dart';

typedef ChildBuilder = Widget Function(void Function()? onTapDebounced);

class DebouncedButton extends StatefulWidget {
  final ChildBuilder childBuilder;
  final Function() onTap;
  final Duration _duration;

  DebouncedButton({
    required this.childBuilder,
    required this.onTap,
    int debounceTimeMs = 300,
  }) : _duration = Duration(milliseconds: debounceTimeMs);

  @override
  DebouncedButtonState createState() => DebouncedButtonState();
}

class DebouncedButtonState extends State<DebouncedButton> {
  final ValueNotifier<bool> _isEnabled = ValueNotifier<bool>(true);
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isEnabled,
      builder: (context, isEnabled, child) => widget.childBuilder(isEnabled ? _executeTap : () => {}),
    );
  }

  void _executeTap() {
    _isEnabled.value = false;
    widget.onTap();
    _timer = Timer(widget._duration, () => _isEnabled.value = true);
  }
}