import 'package:equatable/equatable.dart';

sealed class UserActionCreatePendingState extends Equatable {
  @override
  List<Object?> get props => [];

  int getPendingCreationsCount();
}

class UserActionCreatePendingNotInitializedState extends UserActionCreatePendingState {
  @override
  int getPendingCreationsCount() => 0;
}

class UserActionCreatePendingSuccessState extends UserActionCreatePendingState {
  final int pendingCreationsCount;

  UserActionCreatePendingSuccessState(this.pendingCreationsCount);

  @override
  int getPendingCreationsCount() => pendingCreationsCount;

  @override
  List<Object?> get props => [pendingCreationsCount];
}
