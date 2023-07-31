import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';

class ThematiqueDemarcheRequestAction {}

class ThematiqueDemarcheLoadingAction {}

class ThematiqueDemarcheSuccessAction extends Equatable {
  final List<ThematiqueDeDemarche> thematiques;

  ThematiqueDemarcheSuccessAction(this.thematiques);

  @override
  List<Object> get props => [thematiques];
}

class ThematiqueDemarcheFailureAction {}

class ThematiqueDemarcheResetAction {}
