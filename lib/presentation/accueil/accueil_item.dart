import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/favori.dart';
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

  AccueilCetteSemaineItem({
    required this.rendezvousCount,
    required this.actionsOuDemarchesCount,
    required this.actionsOuDemarchesLabel,
  });

  factory AccueilCetteSemaineItem.from({
    required LoginMode loginMode,
    required int? rendezvousCount,
    required int actionsOuDemarchesCount,
  }) {
    return AccueilCetteSemaineItem(
      rendezvousCount: rendezvousCount?.toString(),
      actionsOuDemarchesCount: actionsOuDemarchesCount.toString(),
      actionsOuDemarchesLabel: _actionsOuDemarchesLabel(loginMode, actionsOuDemarchesCount),
    );
  }

  @override
  List<Object?> get props => [rendezvousCount, actionsOuDemarchesCount, actionsOuDemarchesLabel];
}

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

class AccueilFavorisItem extends AccueilItem {
  final List<Favori> favoris;

  AccueilFavorisItem(this.favoris);

  @override
  List<Object?> get props => [favoris];
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

String _actionsOuDemarchesLabel(LoginMode loginMode, int actionsOuDemarches) {
  final usePlural = actionsOuDemarches > 1;
  if (loginMode.isPe()) {
    return usePlural ? Strings.accueilDemarchePlural : Strings.accueilDemarcheSingular;
  } else {
    return usePlural ? Strings.accueilActionPlural : Strings.accueilActionSingular;
  }
}
