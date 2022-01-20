import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiSearchResultsState extends Equatable {
  OffreEmploiSearchResultsState._();

  factory OffreEmploiSearchResultsState.data({
    required List<OffreEmploi> offres,
    required int loadedPage,
    required bool isMoreDataAvailable,
    bool isLoading = false,
  }) =>
      OffreEmploiSearchResultsDataState(offres, loadedPage, isMoreDataAvailable, isLoading);

  factory OffreEmploiSearchResultsState.notInitialized() = OffreEmploiSearchResultsNotInitializedState;

  @override
  List<Object> get props => [];
}

class OffreEmploiSearchResultsDataState extends OffreEmploiSearchResultsState {
  final List<OffreEmploi> offres;
  final int loadedPage;
  final bool isMoreDataAvailable;
  final bool isLoading;

  OffreEmploiSearchResultsDataState(this.offres, this.loadedPage, this.isMoreDataAvailable, this.isLoading) : super._();

  @override
  List<Object> get props => [offres, loadedPage, isMoreDataAvailable];
}

class OffreEmploiSearchResultsNotInitializedState extends OffreEmploiSearchResultsState {
  OffreEmploiSearchResultsNotInitializedState() : super._();
}
