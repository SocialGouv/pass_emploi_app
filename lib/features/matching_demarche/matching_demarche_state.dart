import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';

sealed class MatchingDemarcheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MatchingDemarcheNotInitializedState extends MatchingDemarcheState {}

class MatchingDemarcheLoadingState extends MatchingDemarcheState {}

class MatchingDemarcheFailureState extends MatchingDemarcheState {}

class MatchingDemarcheSuccessState extends MatchingDemarcheState {
  final MatchingDemarcheDuReferentiel? result;

  MatchingDemarcheSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
