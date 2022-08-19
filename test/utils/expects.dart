import 'package:flutter_test/flutter_test.dart';

void expectTypeThen<T>(dynamic actual, Function(T) expectations) {
  expect(actual, isA<T>());
  final casted = actual as T;
  expectations(casted);
}