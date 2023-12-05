part of 'create_user_action_form_state.dart';

class CreateUserActionStep3State extends CreateUserActionPageState {
  final bool estTerminee;
  final DateTime? date;
  final bool withRappel;

  CreateUserActionStep3State({
    this.estTerminee = false,
    this.date,
    this.withRappel = false,
  });

  @override
  bool get isValid => date != null;

  @override
  List<Object?> get props => [estTerminee, date, withRappel];

  CreateUserActionStep3State copyWith({
    bool? estTerminee,
    DateTime? date,
    bool? withRappel,
  }) {
    return CreateUserActionStep3State(
      estTerminee: estTerminee ?? this.estTerminee,
      date: date ?? this.date,
      withRappel: withRappel ?? this.withRappel,
    );
  }
}
