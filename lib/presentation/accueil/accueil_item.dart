import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/ui/strings.dart';

enum MonSuiviType { actions, demarches }

sealed class AccueilItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccueilCetteSemaineItem extends AccueilItem {
  final MonSuiviType monSuiviType;
  final String rendezVous;
  final String actionsDemarchesEnRetard;
  final String actionsDemarchesARealiser;

  AccueilCetteSemaineItem({
    required this.monSuiviType,
    required this.rendezVous,
    required this.actionsDemarchesEnRetard,
    required this.actionsDemarchesARealiser,
  });

  factory AccueilCetteSemaineItem.from({
    required LoginMode loginMode,
    required int nombreRendezVous,
    required int nombreActionsDemarchesEnRetard,
    required int nombreActionsDemarchesARealiser,
  }) {
    return AccueilCetteSemaineItem(
      monSuiviType: loginMode.isPe() ? MonSuiviType.demarches : MonSuiviType.actions,
      rendezVous: Strings.rendezvousEnCours(nombreRendezVous),
      actionsDemarchesEnRetard: Strings.according(
        loginMode: loginMode,
        count: nombreActionsDemarchesEnRetard,
        singularPoleEmploi: Strings.singularDemarcheLate(nombreActionsDemarchesEnRetard),
        severalPoleEmploi: Strings.severalDemarchesLate(nombreActionsDemarchesEnRetard),
        singularMissionLocale: Strings.singularActionLate(nombreActionsDemarchesEnRetard),
        severalMissionLocale: Strings.severalActionsLate(nombreActionsDemarchesEnRetard),
      ),
      actionsDemarchesARealiser: Strings.according(
        loginMode: loginMode,
        count: nombreActionsDemarchesARealiser,
        singularPoleEmploi: Strings.singularDemarcheToDo(nombreActionsDemarchesARealiser),
        severalPoleEmploi: Strings.severalDemarchesToDo(nombreActionsDemarchesARealiser),
        singularMissionLocale: Strings.singularActionToDo(nombreActionsDemarchesARealiser),
        severalMissionLocale: Strings.severalActionsToDo(nombreActionsDemarchesARealiser),
      ),
    );
  }

  @override
  List<Object?> get props => [monSuiviType, rendezVous, actionsDemarchesEnRetard, actionsDemarchesARealiser];
}

class AccueilProchainRendezvousItem extends AccueilItem {
  final String rendezVousId;

  AccueilProchainRendezvousItem(this.rendezVousId);

  @override
  List<Object?> get props => [rendezVousId];
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

class AccueilCampagneItem extends AccueilItem {
  final String titre;
  final String description;

  AccueilCampagneItem({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}
