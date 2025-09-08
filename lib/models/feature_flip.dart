import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;
  final bool withCampagneRecrutement;

  FeatureFlip({
    required this.useCvm,
    required this.withCampagneRecrutement,
  });

  factory FeatureFlip.initial() {
    return FeatureFlip(
      useCvm: false,
      withCampagneRecrutement: false,
    );
  }

  FeatureFlip copyWith({
    bool? useCvm,
    bool? withCampagneRecrutement,
  }) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
      withCampagneRecrutement: withCampagneRecrutement ?? this.withCampagneRecrutement,
    );
  }

  @override
  List<Object?> get props => [
        useCvm,
        withCampagneRecrutement,
      ];
}
