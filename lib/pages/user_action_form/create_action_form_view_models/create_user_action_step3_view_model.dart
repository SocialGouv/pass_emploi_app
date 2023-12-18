part of 'create_user_action_form_view_model.dart';

sealed class CreateActionDateSource {
  bool get isFromSuggestions => this is CreateActionDateFromSuggestions;
  bool get isFromUserInput => this is CreateActionDateFromUserInput;
  bool get isNone => this is CreateActionDateNotInitialized;

  DateTime get selectedDate => switch (this) {
        // TODO: décharger la responsabilité aux enfants
        CreateActionDateNotInitialized() => DateTime.now(),
        CreateActionDateFromSuggestions() => (this as CreateActionDateFromSuggestions).date,
        CreateActionDateFromUserInput() => (this as CreateActionDateFromUserInput).date,
      };
}

class CreateActionDateNotInitialized extends CreateActionDateSource {}

class CreateActionDateFromSuggestions extends CreateActionDateSource {
  final DateTime date;
  final String label;

  CreateActionDateFromSuggestions(this.date, this.label);
}

class CreateActionDateFromUserInput extends CreateActionDateSource {
  final DateTime date;

  CreateActionDateFromUserInput(this.date);
}

class CreateUserActionStep3ViewModel extends CreateUserActionPageState {
  final bool estTerminee;
  final CreateActionDateSource date;
  final bool withRappel;

  CreateUserActionStep3ViewModel({
    this.estTerminee = true,
    CreateActionDateSource? date,
    this.withRappel = false,
  }) : date = date ?? CreateActionDateNotInitialized();

  @override
  bool get isValid => switch (date) {
        CreateActionDateNotInitialized() => false,
        CreateActionDateFromSuggestions() => true,
        CreateActionDateFromUserInput() => true,
      };

  bool shouldDisplayRappelNotification() =>
      !estTerminee && (DateTime.now().add(Duration(days: 3))).isBefore(date.selectedDate);

  @override
  List<Object?> get props => [estTerminee, date, withRappel];

  CreateUserActionStep3ViewModel copyWith({
    bool? estTerminee,
    CreateActionDateSource? date,
    bool? withRappel,
  }) {
    return CreateUserActionStep3ViewModel(
      estTerminee: estTerminee ?? this.estTerminee,
      date: date ?? this.date,
      withRappel: withRappel ?? this.withRappel,
    );
  }
}
