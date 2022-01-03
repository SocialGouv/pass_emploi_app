import 'package:equatable/equatable.dart';

class CheckboxValueViewModel<T> extends Equatable {
  final String label;
  final T value;
  final bool isInitiallyChecked;

  CheckboxValueViewModel({required this.label, required this.value, required this.isInitiallyChecked});

  @override
  List<Object?> get props => [label, value, isInitiallyChecked];

  @override
  bool? get stringify => true;
}
