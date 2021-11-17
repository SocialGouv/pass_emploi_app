import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiSearchState extends Equatable {
  OffreEmploiSearchState._();

  factory OffreEmploiSearchState.loading() = OffreEmploiSearchLoadingState;

  factory OffreEmploiSearchState.success(List<OffreEmploi> loadedOffres, int loadedPage) =>
      OffreEmploiSearchSuccessState(offres: loadedOffres, loadedPage: loadedPage);

  factory OffreEmploiSearchState.failure() = OffreEmploiSearchFailureState;

  factory OffreEmploiSearchState.notInitialized() = OffreEmploiSearchNotInitializedState;

  @override
  List<Object> get props => [];
}

class OffreEmploiSearchLoadingState extends OffreEmploiSearchState {
  OffreEmploiSearchLoadingState() : super._();
}

class OffreEmploiSearchSuccessState extends OffreEmploiSearchState {
  final List<OffreEmploi> offres;
  final int loadedPage;

  OffreEmploiSearchSuccessState({required this.offres, required this.loadedPage}) : super._();

  @override
  List<Object> get props => [offres, loadedPage];
}

class OffreEmploiSearchFailureState extends OffreEmploiSearchState {
  OffreEmploiSearchFailureState() : super._();
}

class OffreEmploiSearchNotInitializedState extends OffreEmploiSearchState {
  OffreEmploiSearchNotInitializedState() : super._();
}
