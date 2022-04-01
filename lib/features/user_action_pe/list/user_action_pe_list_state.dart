import 'package:pass_emploi_app/models/user_action_pe.dart';

abstract class UserActionPEListState {}

class UserActionPEListNotInitializedState extends UserActionPEListState {}

class UserActionPEListLoadingState extends UserActionPEListState {}

class UserActionPEListSuccessState extends UserActionPEListState {
  final List<UserActionPE> userActions;

  UserActionPEListSuccessState(this.userActions);
}

class UserActionPEListFailureState extends UserActionPEListState {}
