part of 'create_user_action_form_view_model.dart';

class CreateUserActionStep3ViewModel extends CreateUserActionPageViewModel {
  static const minRappelInterval = Duration(days: 3);

  final bool estTerminee;
  final DateInputSource dateSource;
  final bool withRappel;

  CreateUserActionStep3ViewModel({
    this.estTerminee = true,
    DateInputSource? dateSource,
    this.withRappel = false,
  }) : dateSource = dateSource ?? DateNotInitialized();

  @override
  bool get isValid => dateSource.isValid;

  bool shouldDisplayRappelNotification() =>
      !estTerminee && (DateTime.now().add(minRappelInterval)).isBefore(dateSource.selectedDate);

  @override
  List<Object?> get props => [estTerminee, dateSource, withRappel];

  CreateUserActionStep3ViewModel copyWith({
    bool? estTerminee,
    DateInputSource? dateSource,
    bool? withRappel,
  }) {
    return CreateUserActionStep3ViewModel(
      estTerminee: estTerminee ?? this.estTerminee,
      dateSource: dateSource ?? this.dateSource,
      withRappel: withRappel ?? this.withRappel,
    );
  }
}
