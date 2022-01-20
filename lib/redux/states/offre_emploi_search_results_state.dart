import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiSearchResultsState extends Equatable {
  OffreEmploiSearchResultsState._();

  factory OffreEmploiSearchResultsState.data({
    required List<OffreEmploi> offres,
    required int loadedPage,
    required bool isMoreDataAvailable,
  }) =>
      OffreEmploiSearchResultsDataState(offres, loadedPage, isMoreDataAvailable);

  factory OffreEmploiSearchResultsState.notInitialized() = OffreEmploiSearchResultsNotInitializedState;

  @override
  List<Object> get props => [];
}

class OffreEmploiSearchResultsDataState extends OffreEmploiSearchResultsState {
  final List<OffreEmploi> offres;
  final int loadedPage;
  final bool isMoreDataAvailable;

  OffreEmploiSearchResultsDataState(this.offres, this.loadedPage, this.isMoreDataAvailable) : super._();

  @override
  List<Object> get props => [offres, loadedPage, isMoreDataAvailable];
}

class OffreEmploiSearchResultsNotInitializedState extends OffreEmploiSearchResultsState {
  OffreEmploiSearchResultsNotInitializedState() : super._();
}
