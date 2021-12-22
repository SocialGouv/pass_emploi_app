import 'dart:async';

class Debouncer {
  final Duration duration;

  Timer? _timer;

  Debouncer({required this.duration});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }
}
