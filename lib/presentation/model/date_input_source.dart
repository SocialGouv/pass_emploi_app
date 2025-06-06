import 'package:equatable/equatable.dart';

sealed class DateInputSource extends Equatable {
  DateTime get selectedDate;
  bool get isValid;

  bool get isFromSuggestions => this is DateFromSuggestion;
  bool get isFromPicker => this is DateFromPicker;
  bool get isNone => this is DateNotInitialized;
}

class DateNotInitialized extends DateInputSource {
  @override
  DateTime get selectedDate => DateTime.now();

  @override
  bool get isValid => false;

  @override
  List<Object?> get props => [];
}

class DateFromSuggestion extends DateInputSource {
  final DateTime date;
  final String label;

  DateFromSuggestion(this.date, this.label);

  @override
  DateTime get selectedDate => date;

  @override
  bool get isValid => true;

  @override
  List<Object?> get props => [date, label];
}

class DateFromPicker extends DateInputSource {
  final DateTime date;

  DateFromPicker(this.date);

  @override
  DateTime get selectedDate => date;

  @override
  bool get isValid => true;

  @override
  List<Object?> get props => [date];
}
