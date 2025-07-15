import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/comptage_des_heures.dart';

sealed class ComptageDesHeuresState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ComptageDesHeuresNotInitializedState extends ComptageDesHeuresState {}

class ComptageDesHeuresFailureState extends ComptageDesHeuresState {}

class ComptageDesHeuresSuccessState extends ComptageDesHeuresState {
  final ComptageDesHeures comptageDesHeures;
  final int heuresEnCoursDeCalcul;

  ComptageDesHeuresSuccessState({required this.comptageDesHeures, this.heuresEnCoursDeCalcul = 0});

  ComptageDesHeuresSuccessState copyWith({ComptageDesHeures? comptageDesHeures, int? heuresEnCoursDeCalcul}) {
    return ComptageDesHeuresSuccessState(
      comptageDesHeures: comptageDesHeures ?? this.comptageDesHeures,
      heuresEnCoursDeCalcul: heuresEnCoursDeCalcul ?? this.heuresEnCoursDeCalcul,
    );
  }

  @override
  List<Object?> get props => [comptageDesHeures, heuresEnCoursDeCalcul];
}
