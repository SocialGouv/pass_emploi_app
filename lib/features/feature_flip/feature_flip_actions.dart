// TODO: à retirer après avoir informé les utilisateurs de la suppression de CVM
class FeatureFlipUseCvmAction {
  final bool useCvm;

  FeatureFlipUseCvmAction(this.useCvm);
}

class FeatureFlipCampagneRecrutementAction {
  final bool withCampagneRecrutement;

  FeatureFlipCampagneRecrutementAction(this.withCampagneRecrutement);
}

class FeatureFlipMonSuiviDemarchesKoMessageAction {
  final String? withMonSuiviDemarchesKoMessage;

  FeatureFlipMonSuiviDemarchesKoMessageAction(this.withMonSuiviDemarchesKoMessage);
}
