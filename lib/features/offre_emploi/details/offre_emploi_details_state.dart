import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';

abstract class OffreEmploiDetailsState {}

class OffreEmploiDetailsNotInitializedState extends OffreEmploiDetailsState {}

class OffreEmploiDetailsLoadingState extends OffreEmploiDetailsState {}

class OffreEmploiDetailsSuccessState extends OffreEmploiDetailsState {
  final OffreEmploiDetails offre;

  OffreEmploiDetailsSuccessState(this.offre);
}

class OffreEmploiDetailsIncompleteDataState extends OffreEmploiDetailsState {
  final OffreEmploi offre;

  OffreEmploiDetailsIncompleteDataState(this.offre) : super();
}

class OffreEmploiDetailsFailureState extends OffreEmploiDetailsState {}
