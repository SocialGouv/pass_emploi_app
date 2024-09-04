import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;
  final bool usePj;
  final bool withCampagneRecrutement;

  FeatureFlip({
    required this.useCvm,
    required this.usePj,
    required this.withCampagneRecrutement,
  });

  factory FeatureFlip.initial() {
    return FeatureFlip(
      useCvm: false,
      usePj: false,
      withCampagneRecrutement: false,
    );
  }

  FeatureFlip copyWith({
    bool? useCvm,
    bool? usePj,
    bool? withCampagneRecrutement,
    bool? boiteAOutilsMisEnAvant,
    bool? withOffresWording,
  }) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
      usePj: usePj ?? this.usePj,
      withCampagneRecrutement: withCampagneRecrutement ?? this.withCampagneRecrutement,
    );
  }

  @override
  List<Object?> get props => [
        useCvm,
        usePj,
        withCampagneRecrutement,
      ];
}
