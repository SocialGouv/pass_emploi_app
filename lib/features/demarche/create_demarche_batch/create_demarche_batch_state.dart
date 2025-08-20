import 'package:equatable/equatable.dart';

sealed class CreateDemarcheBatchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateDemarcheBatchNotInitializedState extends CreateDemarcheBatchState {}

class CreateDemarcheBatchLoadingState extends CreateDemarcheBatchState {}

class CreateDemarcheBatchFailureState extends CreateDemarcheBatchState {}

class CreateDemarcheBatchSuccessState extends CreateDemarcheBatchState {}
