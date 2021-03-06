import 'package:equatable/equatable.dart';

abstract class OffreEmploiSearchState extends Equatable {
  OffreEmploiSearchState._();

  factory OffreEmploiSearchState.loading() = OffreEmploiSearchLoadingState;

  factory OffreEmploiSearchState.success() = OffreEmploiSearchSuccessState;

  factory OffreEmploiSearchState.failure() = OffreEmploiSearchFailureState;

  factory OffreEmploiSearchState.notInitialized() = OffreEmploiSearchNotInitializedState;

  @override
  List<Object> get props => [];
}

class OffreEmploiSearchLoadingState extends OffreEmploiSearchState {
  OffreEmploiSearchLoadingState() : super._();
}

class OffreEmploiSearchSuccessState extends OffreEmploiSearchState {
  OffreEmploiSearchSuccessState() : super._();
}

class OffreEmploiSearchFailureState extends OffreEmploiSearchState {
  OffreEmploiSearchFailureState() : super._();
}

class OffreEmploiSearchNotInitializedState extends OffreEmploiSearchState {
  OffreEmploiSearchNotInitializedState() : super._();
}
