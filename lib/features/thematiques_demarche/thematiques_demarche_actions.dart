import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';

class ThematiquesDemarcheRequestAction {}

class ThematiquesDemarcheLoadingAction {}

class ThematiquesDemarcheSuccessAction extends Equatable {
  final List<ThematiqueDeDemarche> thematiques;

  ThematiquesDemarcheSuccessAction(this.thematiques);

  @override
  List<Object> get props => [thematiques];
}

class ThematiquesDemarcheFailureAction {}

class ThematiquesDemarcheResetAction {}
