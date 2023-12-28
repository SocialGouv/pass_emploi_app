import 'package:collection/collection.dart';

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinct() {
    final seen = <T>{};
    return where((e) => seen.add(e));
  }

  Iterable<T> take(int max) => whereIndexed((index, element) => index < max);
}

extension OrEmptyIterable<T> on Iterable<T>? {
  Iterable<T> orEmpty() => this ?? [];
}
