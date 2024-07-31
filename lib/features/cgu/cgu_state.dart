import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/cgu.dart';

sealed class CguState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CguNotInitializedState extends CguState {}

class CguAlreadyAcceptedState extends CguState {}

class CguNeverAcceptedState extends CguState {}

class CguUpdateRequiredState extends CguState {
  final Cgu updatedCgu;

  CguUpdateRequiredState(this.updatedCgu);

  @override
  List<Object?> get props => [updatedCgu];
}
