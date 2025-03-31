import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;
  final bool withCampagneRecrutement;
  final bool withNouvelleSaisieDemarche;

  FeatureFlip({
    required this.useCvm,
    required this.withCampagneRecrutement,
    required this.withNouvelleSaisieDemarche,
  });

  factory FeatureFlip.initial() {
    return FeatureFlip(
      useCvm: false,
      withCampagneRecrutement: false,
      withNouvelleSaisieDemarche: false,
    );
  }

  FeatureFlip copyWith({
    bool? useCvm,
    bool? withCampagneRecrutement,
    bool? withNouvelleSaisieDemarche,
  }) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
      withCampagneRecrutement: withCampagneRecrutement ?? this.withCampagneRecrutement,
      withNouvelleSaisieDemarche: withNouvelleSaisieDemarche ?? this.withNouvelleSaisieDemarche,
    );
  }

  @override
  List<Object?> get props => [
        useCvm,
        withCampagneRecrutement,
        withNouvelleSaisieDemarche,
      ];
}
