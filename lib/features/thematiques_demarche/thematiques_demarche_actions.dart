import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';

class ThematiquesDemarcheRequestAction {}

class ThematiquesDemarcheLoadingAction {}

class ThematiquesDemarcheSuccessAction extends Equatable {
  final List<ThematiqueDeDemarche> result;

  ThematiquesDemarcheSuccessAction(this.result);

  @override
  List<Object> get props => [result];
}

class ThematiquesDemarcheFailureAction {}

class ThematiquesDemarcheResetAction {}
