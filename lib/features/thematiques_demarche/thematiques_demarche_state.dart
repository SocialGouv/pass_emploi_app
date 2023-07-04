import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';

sealed class ThematiquesDemarcheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThematiquesDemarcheNotInitializedState extends ThematiquesDemarcheState {}

class ThematiquesDemarcheLoadingState extends ThematiquesDemarcheState {}

class ThematiquesDemarcheFailureState extends ThematiquesDemarcheState {}

class ThematiquesDemarcheSuccessState extends ThematiquesDemarcheState {
  final List<ThematiqueDeDemarche> thematiques;

  ThematiquesDemarcheSuccessState(this.thematiques);

  @override
  List<Object?> get props => [thematiques];
}
