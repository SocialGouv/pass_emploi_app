import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionListState {}

class UserActionListNotInitializedState extends UserActionListState {}

class UserActionListLoadingState extends UserActionListState {}

class UserActionListSuccessState extends UserActionListState {
  final List<UserAction> userActions;
  final Campagne? campagne;

  UserActionListSuccessState(this.userActions, [this.campagne]);
}

class UserActionListFailureState extends UserActionListState {}
