import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';

abstract class ImmersionSearchState extends Equatable {
  ImmersionSearchState._();

  factory ImmersionSearchState.loading() = ImmersionSearchLoadingState;

  factory ImmersionSearchState.success(List<Immersion> immersions) = ImmersionSearchSuccessState;

  factory ImmersionSearchState.failure() = ImmersionSearchFailureState;

  factory ImmersionSearchState.notInitialized() = ImmersionSearchNotInitializedState;

  @override
  List<Object> get props => [];
}

class ImmersionSearchLoadingState extends ImmersionSearchState {
  ImmersionSearchLoadingState() : super._();
}

class ImmersionSearchSuccessState extends ImmersionSearchState {
  final List<Immersion> immersions;

  ImmersionSearchSuccessState(this.immersions) : super._();

  @override
  List<Object> get props => [immersions];
}

class ImmersionSearchFailureState extends ImmersionSearchState {
  ImmersionSearchFailureState() : super._();
}

class ImmersionSearchNotInitializedState extends ImmersionSearchState {
  ImmersionSearchNotInitializedState() : super._();
}
