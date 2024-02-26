import 'package:equatable/equatable.dart';

sealed class CampagneRecrutementState extends Equatable {
  @override
  List<Object?> get props => [];

  bool get shouldShowCampagneRecrutement => switch (this) {
        final CampagneRecrutementResultState success => success.withCampagneRecrutement,
        _ => false,
      };
}

class CampagneRecrutementNotInitializedState extends CampagneRecrutementState {}

class CampagneRecrutementResultState extends CampagneRecrutementState {
  final bool withCampagneRecrutement;

  CampagneRecrutementResultState(this.withCampagneRecrutement);

  @override
  List<Object?> get props => [withCampagneRecrutement];
}
