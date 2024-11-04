import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;
  final bool withCampagneRecrutement;
  final bool withCje;

  FeatureFlip({
    required this.useCvm,
    required this.withCampagneRecrutement,
    required this.withCje,
  });

  factory FeatureFlip.initial() {
    return FeatureFlip(
      useCvm: false,
      withCampagneRecrutement: false,
      withCje: false,
    );
  }

  FeatureFlip copyWith({
    bool? useCvm,
    bool? withCampagneRecrutement,
    bool? withCje,
  }) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
      withCampagneRecrutement: withCampagneRecrutement ?? this.withCampagneRecrutement,
      withCje: withCje ?? this.withCje,
    );
  }

  @override
  List<Object?> get props => [
        useCvm,
        withCampagneRecrutement,
        withCje,
      ];
}
