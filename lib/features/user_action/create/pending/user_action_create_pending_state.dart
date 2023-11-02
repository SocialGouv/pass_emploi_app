import 'package:equatable/equatable.dart';

sealed class UserActionCreatePendingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserActionCreatePendingNotInitializedState extends UserActionCreatePendingState {}

class UserActionCreatePendingSuccessState extends UserActionCreatePendingState {
  final int pendingCreationsCount;

  UserActionCreatePendingSuccessState(this.pendingCreationsCount);

  @override
  List<Object?> get props => [pendingCreationsCount];
}
