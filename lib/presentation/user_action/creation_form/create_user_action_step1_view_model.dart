part of 'create_user_action_form_view_model.dart';

class CreateUserActionStep1ViewModel extends CreateUserActionPageViewModel {
  final UserActionReferentielType? actionCategory;

  CreateUserActionStep1ViewModel({this.actionCategory});

  @override
  bool get isValid => actionCategory != null;

  @override
  List<Object?> get props => [actionCategory];

  CreateUserActionStep1ViewModel copyWith({
    UserActionReferentielType? type,
  }) {
    return CreateUserActionStep1ViewModel(
      actionCategory: type ?? actionCategory,
    );
  }
}
