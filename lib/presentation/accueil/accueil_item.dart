import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/ui/strings.dart';

enum MonSuiviType { actions, demarches }

sealed class AccueilItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccueilCetteSemaineItem extends AccueilItem {
  final String? rendezvousCount;
  final String actionsOuDemarchesCount;
  final String actionsOuDemarchesLabel;
  final bool withComptageDesHeures;

  AccueilCetteSemaineItem({
    required this.rendezvousCount,
    required this.actionsOuDemarchesCount,
    required this.actionsOuDemarchesLabel,
    required this.withComptageDesHeures,
  });

  factory AccueilCetteSemaineItem.from({
    required LoginMode loginMode,
    required int? rendezvousCount,
    required int actionsOuDemarchesCount,
    required bool withComptageDesHeures,
  }) {
    return AccueilCetteSemaineItem(
      rendezvousCount: rendezvousCount?.toString(),
      actionsOuDemarchesCount: actionsOuDemarchesCount.toString(),
      actionsOuDemarchesLabel: _actionsOuDemarchesLabel(loginMode, actionsOuDemarchesCount),
      withComptageDesHeures: withComptageDesHeures,
    );
  }

  @override
  List<Object?> get props => [rendezvousCount, actionsOuDemarchesCount, actionsOuDemarchesLabel];
}

class AccueilColorSeparatorItem extends AccueilItem {}

class AccueilProchainRendezvousItem extends AccueilItem {
  final String rendezvousId;

  AccueilProchainRendezvousItem(this.rendezvousId);

  @override
  List<Object?> get props => [rendezvousId];
}

class AccueilProchaineSessionMiloItem extends AccueilItem {
  final String sessionId;

  AccueilProchaineSessionMiloItem(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

enum AccueilEvenementsType { animationCollective, sessionMilo }

class AccueilEvenementsItem extends AccueilItem {
  final List<(String, AccueilEvenementsType)> evenements;

  AccueilEvenementsItem(this.evenements);

  @override
  List<Object?> get props => [evenements];
}

class AccueilAlertesItem extends AccueilItem {
  final List<Alerte> alertes;

  AccueilAlertesItem(this.alertes);

  @override
  List<Object?> get props => [alertes];
}

class AccueilSuiviDesOffresItem extends AccueilItem {
  AccueilSuiviDesOffresItem();

  @override
  List<Object?> get props => [];
}

class AccueilOutilsItem extends AccueilItem {
  final List<Outil> outils;

  AccueilOutilsItem(this.outils);

  @override
  List<Object?> get props => [outils];
}

class CampagneEvaluationItem extends AccueilItem {
  final String titre;
  final String description;

  CampagneEvaluationItem({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}

class CampagneRecrutementItem extends AccueilItem {
  final void Function() onDismiss;

  CampagneRecrutementItem({required this.onDismiss});
}

class RatingAppItem extends AccueilItem {}

class RemoteCampagneAccueilItem extends AccueilItem {
  final String title;
  final String cta;
  final String url;
  final void Function() onDismissed;

  RemoteCampagneAccueilItem({required this.title, required this.cta, required this.url, required this.onDismissed});

  @override
  List<Object?> get props => [title, cta, url];
}

class OffreSuivieAccueilItem extends AccueilItem {
  final String offreId;

  OffreSuivieAccueilItem({required this.offreId});

  @override
  List<Object?> get props => [offreId];
}

class ErrorDegradeeItem extends AccueilItem {
  final String message;

  ErrorDegradeeItem(this.message);

  @override
  List<Object?> get props => [message];
}

class OnboardingItem extends AccueilItem {
  final int completedSteps;
  final int totalSteps;

  OnboardingItem({
    required this.completedSteps,
    required this.totalSteps,
  });

  @override
  List<Object?> get props => [completedSteps, totalSteps];
}

String _actionsOuDemarchesLabel(LoginMode loginMode, int actionsOuDemarches) {
  final usePlural = actionsOuDemarches > 1;
  if (loginMode.isPe()) {
    return usePlural ? Strings.accueilDemarchePlural : Strings.accueilDemarcheSingular;
  } else {
    return usePlural ? Strings.accueilActionPlural : Strings.accueilActionSingular;
  }
}
