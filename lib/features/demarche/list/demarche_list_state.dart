import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';

abstract class DemarcheListState extends Equatable {
  @override
  List<Object> get props => [];
}

class DemarcheListNotInitializedState extends DemarcheListState {}

class DemarcheListLoadingState extends DemarcheListState {}

class DemarcheListSuccessState extends DemarcheListState {
  final List<Demarche> userActions;
  final bool isDetailAvailable;

  DemarcheListSuccessState(this.userActions, this.isDetailAvailable);

  @override
  List<Object> get props => [userActions, isDetailAvailable];
}

class DemarcheListFailureState extends DemarcheListState {}
