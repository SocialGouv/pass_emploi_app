part of 'create_user_action_form_state.dart';

class CreateUserActionStep1State extends CreateUserActionPageState {
  final UserActionReferentielType? actionCategory;

  CreateUserActionStep1State({this.actionCategory});

  @override
  bool get isValid => actionCategory != null;

  @override
  List<Object?> get props => [actionCategory];

  CreateUserActionStep1State copyWith({
    UserActionReferentielType? type,
  }) {
    return CreateUserActionStep1State(
      actionCategory: type ?? actionCategory,
    );
  }
}
