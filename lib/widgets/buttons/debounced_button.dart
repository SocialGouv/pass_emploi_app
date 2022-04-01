import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedButton extends StatefulWidget {
  final Widget Function(void Function()?) _childBuilder;
  final Function() _onTap;
  final Duration _duration;

  DebouncedButton({
    required Widget Function(void Function()?) childBuilder,
    required Function() onTap,
    int debounceTimeMs = 300,
  })  : this._childBuilder = childBuilder,
        this._onTap = onTap,
        this._duration = Duration(milliseconds: debounceTimeMs);

  @override
  _DebouncedButtonState createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
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
      builder: (context, isEnabled, child) => widget._childBuilder(isEnabled ? _onTapDebounced : () => {}),
    );
  }

  void _onTapDebounced() {
    _isEnabled.value = false;
    widget._onTap();
    _timer = Timer(widget._duration, () => _isEnabled.value = true);
  }
}