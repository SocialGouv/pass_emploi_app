import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';

abstract class UserActionPEListState {}

class UserActionPEListNotInitializedState extends UserActionPEListState {}

class UserActionPEListLoadingState extends UserActionPEListState {}

class UserActionPEListSuccessState extends UserActionPEListState {
  final List<UserActionPE> userActions;
  final Campagne? campagne;
  final bool isDetailAvailable;

  UserActionPEListSuccessState(this.userActions, this.isDetailAvailable, [this.campagne]);
}

class UserActionPEListFailureState extends UserActionPEListState {}
