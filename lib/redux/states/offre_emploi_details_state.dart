import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';

abstract class OffreEmploiDetailsState extends Equatable {
  OffreEmploiDetailsState._();

  factory OffreEmploiDetailsState.loading() = OffreEmploiDetailsLoadingState;

  factory OffreEmploiDetailsState.success(OffreEmploiDetails offre) = OffreEmploiDetailsSuccessState;

  factory OffreEmploiDetailsState.failure() = OffreEmploiDetailsFailureState;

  factory OffreEmploiDetailsState.notInitialized() = OffreEmploiDetailsNotInitializedState;

  factory OffreEmploiDetailsState.incompleteData(OffreEmploi offreEmploi) = OffreEmploiDetailsIncompleteDataState;

  @override
  List<Object> get props => [];
}

class OffreEmploiDetailsLoadingState extends OffreEmploiDetailsState {
  OffreEmploiDetailsLoadingState() : super._();
}

class OffreEmploiDetailsSuccessState extends OffreEmploiDetailsState {
  final OffreEmploiDetails offre;

  OffreEmploiDetailsSuccessState(this.offre) : super._();

  @override
  List<Object> get props => [offre];
}

class OffreEmploiDetailsFailureState extends OffreEmploiDetailsState {
  OffreEmploiDetailsFailureState() : super._();
}

class OffreEmploiDetailsNotInitializedState extends OffreEmploiDetailsState {
  OffreEmploiDetailsNotInitializedState() : super._();
}

class OffreEmploiDetailsIncompleteDataState extends OffreEmploiDetailsState {
  final OffreEmploi offreEmploi;

  OffreEmploiDetailsIncompleteDataState(this.offreEmploi) : super._();
}