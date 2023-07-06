import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';

sealed class ThematiqueDemarcheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThematiqueDemarcheNotInitializedState extends ThematiqueDemarcheState {}

class ThematiqueDemarcheLoadingState extends ThematiqueDemarcheState {}

class ThematiqueDemarcheFailureState extends ThematiqueDemarcheState {}

class ThematiqueDemarcheSuccessState extends ThematiqueDemarcheState {
  final List<ThematiqueDeDemarche> thematiques;

  ThematiqueDemarcheSuccessState(this.thematiques);

  @override
  List<Object?> get props => [thematiques];
}
