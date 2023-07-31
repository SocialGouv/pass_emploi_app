import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';

sealed class TopDemarcheState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopDemarcheNotInitializedState extends TopDemarcheState {}

class TopDemarcheSuccessState extends TopDemarcheState {
  final List<DemarcheDuReferentiel> demarches;

  TopDemarcheSuccessState(this.demarches);

  @override
  List<Object?> get props => [demarches];
}
