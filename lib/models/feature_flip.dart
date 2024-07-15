import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;
  final bool usePj;
  final bool withCampagneRecrutement;
  final bool boiteAOutilsMisEnAvant;

  FeatureFlip({
    required this.useCvm,
    required this.usePj,
    required this.withCampagneRecrutement,
    required this.boiteAOutilsMisEnAvant,
  });

  factory FeatureFlip.initial() {
    return FeatureFlip(
      useCvm: false,
      usePj: false,
      withCampagneRecrutement: false,
      boiteAOutilsMisEnAvant: false,
    );
  }

  FeatureFlip copyWith({
    bool? useCvm,
    bool? usePj,
    bool? withCampagneRecrutement,
    bool? boiteAOutilsMisEnAvant,
  }) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
      usePj: usePj ?? this.usePj,
      withCampagneRecrutement: withCampagneRecrutement ?? this.withCampagneRecrutement,
      boiteAOutilsMisEnAvant: boiteAOutilsMisEnAvant ?? this.boiteAOutilsMisEnAvant,
    );
  }

  @override
  List<Object?> get props => [useCvm, usePj, withCampagneRecrutement, boiteAOutilsMisEnAvant];
}
