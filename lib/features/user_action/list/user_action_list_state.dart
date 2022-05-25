import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionListState {}

class UserActionListNotInitializedState extends UserActionListState {}

class UserActionListLoadingState extends UserActionListState {}

class UserActionListSuccessState extends UserActionListState {
  final List<UserAction> userActions;

  UserActionListSuccessState(this.userActions);
}

class UserActionListFailureState extends UserActionListState {}
