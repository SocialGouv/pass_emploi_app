part of 'create_user_action_form_state.dart';

enum UserActionCategory {
  emploi,
  projetPro,
  sportLoisir,
  citoyennete,
  formation,
  logement,
  sante,
}

class CreateUserActionStep1State extends CreateUserActionPageState {
  final UserActionCategory? actionCategory;

  CreateUserActionStep1State({this.actionCategory});

  @override
  bool get isValid => actionCategory != null;

  @override
  List<Object?> get props => [actionCategory];

  CreateUserActionStep1State copyWith({
    UserActionCategory? actionCategory,
  }) {
    return CreateUserActionStep1State(
      actionCategory: actionCategory ?? this.actionCategory,
    );
  }
}
