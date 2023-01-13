// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pass_emploi_app/models/demarche.dart';

class DemarcheListRequestAction {}

class DemarcheListLoadingAction {}

class DemarcheListRequestReloadAction {}

class DemarcheListReloadingAction {}

class DemarcheListSuccessAction {
  final List<Demarche> demarches;
  final DateTime? dateDerniereMiseAJour;

  DemarcheListSuccessAction(this.demarches, [this.dateDerniereMiseAJour]);
}

class DemarcheListFailureAction {}

class DemarcheListResetAction {}
