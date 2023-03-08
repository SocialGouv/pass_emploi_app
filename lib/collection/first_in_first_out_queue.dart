import 'dart:collection';

class FirstInFirstOutQueue<E> {
  final int _capacity;
  late ListQueue<E> _queue;

  FirstInFirstOutQueue(this._capacity) {
    _queue = ListQueue<E>(_capacity);
  }

  void add(E element) {
    _queue.addFirst(element);
    while (_queue.length > _capacity) {
      _queue.removeLast();
    }
  }

  List<E> toList() => _queue.toList();
}
