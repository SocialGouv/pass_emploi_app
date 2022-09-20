import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';

abstract class DemarcheListState extends Equatable {
  @override
  List<Object> get props => [];
}

class DemarcheListNotInitializedState extends DemarcheListState {}

class DemarcheListLoadingState extends DemarcheListState {}

class DemarcheListSuccessState extends DemarcheListState {
  final List<Demarche> demarches;

  DemarcheListSuccessState(this.demarches);

  @override
  List<Object> get props => [demarches];
}

class DemarcheListFailureState extends DemarcheListState {}
