part of 'create_user_action_form_state.dart';

sealed class CreateActionDateSource {
  bool get isFromSuggestions => this is CreateActionDateFromSuggestions;
  bool get isFromUserInput => this is CreateActionDateFromUserInput;
  bool get isNone => this is CreateActionDateNone;

  DateTime get selectedDate => switch (this) {
        CreateActionDateNone() => DateTime.now(),
        CreateActionDateFromSuggestions() => (this as CreateActionDateFromSuggestions).date,
        CreateActionDateFromUserInput() => (this as CreateActionDateFromUserInput).date,
      };
}

class CreateActionDateNone extends CreateActionDateSource {}

class CreateActionDateFromSuggestions extends CreateActionDateSource {
  final DateTime date;
  final String label;

  CreateActionDateFromSuggestions(this.date, this.label);
}

class CreateActionDateFromUserInput extends CreateActionDateSource {
  final DateTime date;

  CreateActionDateFromUserInput(this.date);
}

class CreateUserActionStep3State extends CreateUserActionPageState {
  final bool estTerminee;
  final CreateActionDateSource date;
  final bool withRappel;

  CreateUserActionStep3State({
    this.estTerminee = true,
    CreateActionDateSource? date,
    this.withRappel = false,
  }) : date = date ?? CreateActionDateNone();

  @override
  bool get isValid => switch (date) {
        CreateActionDateNone() => false,
        CreateActionDateFromSuggestions() => true,
        CreateActionDateFromUserInput() => true,
      };

  bool shouldDisplayRappelNotification() =>
      !estTerminee && (DateTime.now().add(Duration(days: 3))).isBefore(date.selectedDate);

  @override
  List<Object?> get props => [estTerminee, date, withRappel];

  CreateUserActionStep3State copyWith({
    bool? estTerminee,
    CreateActionDateSource? date,
    bool? withRappel,
  }) {
    return CreateUserActionStep3State(
      estTerminee: estTerminee ?? this.estTerminee,
      date: date ?? this.date,
      withRappel: withRappel ?? this.withRappel,
    );
  }
}
