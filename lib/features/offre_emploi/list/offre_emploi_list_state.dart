import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

abstract class OffreEmploiListState extends Equatable {
  OffreEmploiListState._();

  factory OffreEmploiListState.data({
    required List<OffreEmploi> offres,
    required int loadedPage,
    required bool isMoreDataAvailable,
  }) {
    return OffreEmploiListSuccessState(offres, loadedPage, isMoreDataAvailable);
  }

  factory OffreEmploiListState.notInitialized() = OffreEmploiListNotInitializedState;

  @override
  List<Object> get props => [];
}

class OffreEmploiListSuccessState extends OffreEmploiListState {
  final List<OffreEmploi> offres;
  final int loadedPage;
  final bool isMoreDataAvailable;

  OffreEmploiListSuccessState(this.offres, this.loadedPage, this.isMoreDataAvailable) : super._();

  @override
  List<Object> get props => [offres, loadedPage, isMoreDataAvailable];
}

class OffreEmploiListNotInitializedState extends OffreEmploiListState {
  OffreEmploiListNotInitializedState() : super._();
}
