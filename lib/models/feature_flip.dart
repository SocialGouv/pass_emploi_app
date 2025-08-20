import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;
  final bool withCampagneRecrutement;
  final bool useIaFt;

  FeatureFlip({
    required this.useCvm,
    required this.withCampagneRecrutement,
    required this.useIaFt,
  });

  factory FeatureFlip.initial() {
    return FeatureFlip(
      useCvm: false,
      withCampagneRecrutement: false,
      useIaFt: false,
    );
  }

  FeatureFlip copyWith({
    bool? useCvm,
    bool? withCampagneRecrutement,
    bool? useIaFt,
  }) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
      withCampagneRecrutement: withCampagneRecrutement ?? this.withCampagneRecrutement,
      useIaFt: useIaFt ?? this.useIaFt,
    );
  }

  @override
  List<Object?> get props => [
        useCvm,
        withCampagneRecrutement,
        useIaFt,
      ];
}
