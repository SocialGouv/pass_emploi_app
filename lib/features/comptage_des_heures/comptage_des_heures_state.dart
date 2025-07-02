import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/comptage_des_heures.dart';

sealed class ComptageDesHeuresState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ComptageDesHeuresNotInitializedState extends ComptageDesHeuresState {}

class ComptageDesHeuresLoadingState extends ComptageDesHeuresState {}

class ComptageDesHeuresFailureState extends ComptageDesHeuresState {}

class ComptageDesHeuresSuccessState extends ComptageDesHeuresState {
  final ComptageDesHeures comptageDesHeures;

  ComptageDesHeuresSuccessState(this.comptageDesHeures);

  @override
  List<Object?> get props => [comptageDesHeures];
}
