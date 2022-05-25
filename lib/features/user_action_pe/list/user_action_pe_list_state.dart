import 'package:pass_emploi_app/models/user_action_pe.dart';

abstract class UserActionPEListState {}

class UserActionPEListNotInitializedState extends UserActionPEListState {}

class UserActionPEListLoadingState extends UserActionPEListState {}

class UserActionPEListSuccessState extends UserActionPEListState {
  final List<UserActionPE> userActions;
  final bool isDetailAvailable;

  UserActionPEListSuccessState(this.userActions, this.isDetailAvailable);
}

class UserActionPEListFailureState extends UserActionPEListState {}
