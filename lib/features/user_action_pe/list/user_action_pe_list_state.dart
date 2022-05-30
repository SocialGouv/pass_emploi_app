import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';

abstract class UserActionPEListState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserActionPEListNotInitializedState extends UserActionPEListState {}

class UserActionPEListLoadingState extends UserActionPEListState {}

class UserActionPEListSuccessState extends UserActionPEListState {
  final List<UserActionPE> userActions;
  final bool isDetailAvailable;

  UserActionPEListSuccessState(this.userActions, this.isDetailAvailable);

  @override
  List<Object> get props => [userActions, isDetailAvailable];
}

class UserActionPEListFailureState extends UserActionPEListState {}
