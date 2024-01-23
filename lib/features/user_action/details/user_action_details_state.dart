import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action.dart';

sealed class UserActionDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserActionDetailsNotInitializedState extends UserActionDetailsState {}

class UserActionDetailsLoadingState extends UserActionDetailsState {}

class UserActionDetailsFailureState extends UserActionDetailsState {}

class UserActionDetailsSuccessState extends UserActionDetailsState {
  final UserAction result;

  UserActionDetailsSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
