import 'package:equatable/equatable.dart';

sealed class CampagneRecrutementState extends Equatable {
  @override
  List<Object?> get props => [];

  bool get shouldShowCampagneRecrutement => switch (this) {
        final CampagneRecrutementSuccessState success => success.result,
        _ => false,
      };
}

class CampagneRecrutementNotInitializedState extends CampagneRecrutementState {}

class CampagneRecrutementLoadingState extends CampagneRecrutementState {}

class CampagneRecrutementFailureState extends CampagneRecrutementState {}

class CampagneRecrutementSuccessState extends CampagneRecrutementState {
  final bool result;

  CampagneRecrutementSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
