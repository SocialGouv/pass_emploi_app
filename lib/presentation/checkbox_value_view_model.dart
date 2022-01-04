import 'package:equatable/equatable.dart';

class CheckboxValueViewModel<T> extends Equatable {
  final String label;
  final String? helpText;
  final T value;
  final bool isInitiallyChecked;

  CheckboxValueViewModel({required this.label, this.helpText, required this.value, required this.isInitiallyChecked});

  @override
  List<Object?> get props => [label, helpText, value, isInitiallyChecked];

  @override
  bool? get stringify => true;
}
