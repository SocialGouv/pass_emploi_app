import 'dart:collection';

class LastInFirstOutQueue<E> {
  final int _capacity;
  late ListQueue<E> _queue;

  LastInFirstOutQueue(this._capacity) {
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
