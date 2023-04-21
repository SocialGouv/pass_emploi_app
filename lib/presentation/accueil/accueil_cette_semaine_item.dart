import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';

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
