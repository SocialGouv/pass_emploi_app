import 'package:equatable/equatable.dart';

abstract class DemarcheCreationState extends Equatable {
  @override
  List<Object> get props => [];
}

class DemarcheCreationPendingState extends DemarcheCreationState {}

class DemarcheCreationSuccessState extends DemarcheCreationState {
  final String demarcheCreatedId;

  DemarcheCreationSuccessState(this.demarcheCreatedId);

  @override
  List<Object> get props => [demarcheCreatedId];
}
