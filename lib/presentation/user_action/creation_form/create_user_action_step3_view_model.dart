part of 'create_user_action_form_view_model.dart';

sealed class CreateActionDateSource {
  DateTime get selectedDate;
  bool get isValid;

  bool get isFromSuggestions => this is CreateActionDateFromSuggestions;
  bool get isFromUserInput => this is CreateActionDateFromUserInput;
  bool get isNone => this is CreateActionDateNotInitialized;
}

class CreateActionDateNotInitialized extends CreateActionDateSource {
  @override
  DateTime get selectedDate => DateTime.now();

  @override
  bool get isValid => false;
}

class CreateActionDateFromSuggestions extends CreateActionDateSource {
  final DateTime date;
  final String label;

  CreateActionDateFromSuggestions(this.date, this.label);

  @override
  DateTime get selectedDate => date;

  @override
  bool get isValid => true;
}

class CreateActionDateFromUserInput extends CreateActionDateSource {
  final DateTime date;

  CreateActionDateFromUserInput(this.date);

  @override
  DateTime get selectedDate => date;

  @override
  bool get isValid => true;
}

class CreateUserActionStep3ViewModel extends CreateUserActionPageViewModel {
  static const minRappelInterval = Duration(days: 3);

  final bool estTerminee;
  final CreateActionDateSource dateSource;
  final bool withRappel;

  CreateUserActionStep3ViewModel({
    this.estTerminee = true,
    CreateActionDateSource? dateSource,
    this.withRappel = false,
  }) : dateSource = dateSource ?? CreateActionDateNotInitialized();

  @override
  bool get isValid => dateSource.isValid;

  bool shouldDisplayRappelNotification() =>
      !estTerminee && (DateTime.now().add(minRappelInterval)).isBefore(dateSource.selectedDate);

  @override
  List<Object?> get props => [estTerminee, dateSource, withRappel];

  CreateUserActionStep3ViewModel copyWith({
    bool? estTerminee,
    CreateActionDateSource? dateSource,
    bool? withRappel,
  }) {
    return CreateUserActionStep3ViewModel(
      estTerminee: estTerminee ?? this.estTerminee,
      dateSource: dateSource ?? this.dateSource,
      withRappel: withRappel ?? this.withRappel,
    );
  }
}
