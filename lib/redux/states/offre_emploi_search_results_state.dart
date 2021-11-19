import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiSearchResultsState extends Equatable {
  OffreEmploiSearchResultsState._();

  factory OffreEmploiSearchResultsState.data(List<OffreEmploi> offres, int loadedPage) = OffreEmploiSearchResultsDataState;

  factory OffreEmploiSearchResultsState.notInitialized() = OffreEmploiSearchResultsNotInitializedState;

  @override
  List<Object> get props => [];
}

class OffreEmploiSearchResultsDataState extends OffreEmploiSearchResultsState {
  final List<OffreEmploi> offres;
  final int loadedPage;

  OffreEmploiSearchResultsDataState(this.offres,this.loadedPage) : super._();

  @override
  List<Object> get props => [offres, loadedPage];
}

class OffreEmploiSearchResultsNotInitializedState extends OffreEmploiSearchResultsState {
  OffreEmploiSearchResultsNotInitializedState() : super._();
}
