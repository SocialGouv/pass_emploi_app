import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;
  final bool withCampagneRecrutement;
  final String? withMonSuiviDemarchesKoMessage;

  FeatureFlip({
    required this.useCvm,
    required this.withCampagneRecrutement,
    required this.withMonSuiviDemarchesKoMessage,
  });

  factory FeatureFlip.initial() {
    return FeatureFlip(
      useCvm: false,
      withCampagneRecrutement: false,
      withMonSuiviDemarchesKoMessage: null,
    );
  }

  FeatureFlip copyWith({
    bool? useCvm,
    bool? withCampagneRecrutement,
    String? withMonSuiviDemarchesKoMessage,
  }) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
      withCampagneRecrutement: withCampagneRecrutement ?? this.withCampagneRecrutement,
      withMonSuiviDemarchesKoMessage: withMonSuiviDemarchesKoMessage ?? this.withMonSuiviDemarchesKoMessage,
    );
  }

  @override
  List<Object?> get props => [
        useCvm,
        withCampagneRecrutement,
        withMonSuiviDemarchesKoMessage,
      ];
}
