import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class AccueilViewModel extends Equatable {
  final DisplayState displayState;
  final List<AccueilItem> items;
  final Function() retry;

  AccueilViewModel({
    required this.displayState,
    required this.items,
    required this.retry,
  });

  factory AccueilViewModel.create(Store<AppState> store) {
    return AccueilViewModel(
      displayState: _displayState(store),
      items: _items(store),
      retry: () => store.dispatch(AccueilRequestAction()),
    );
  }

  @override
  List<Object?> get props => [items];
}

DisplayState _displayState(Store<AppState> store) {
  final accueilState = store.state.accueilState;
  if (accueilState is AccueilSuccessState) return DisplayState.CONTENT;
  if (accueilState is AccueilFailureState) return DisplayState.FAILURE;
  return DisplayState.LOADING;
}

List<AccueilItem> _items(Store<AppState> store) {
  final accueilState = store.state.accueilState;
  final user = store.state.user();
  if (accueilState is! AccueilSuccessState || user == null) return [];

  return [
    _cetteSemaineItem(user.loginMode, accueilState),
    _prochainRendezvousItem(accueilState),
    _evenementsItem(accueilState),
    _alertesItem(accueilState),
    _favorisItem(accueilState),
    _outilsItem(accueilState),
  ].whereNotNull().toList();
}

AccueilItem? _cetteSemaineItem(LoginMode loginMode, AccueilSuccessState successState) {
  final cetteSemaine = successState.accueil.cetteSemaine;
  if (cetteSemaine == null) return null;

  return AccueilCetteSemaineItem.from(
    loginMode: loginMode,
    nombreRendezVous: cetteSemaine.nombreRendezVous,
    nombreActionsDemarchesEnRetard: cetteSemaine.nombreActionsDemarchesEnRetard,
    nombreActionsDemarchesARealiser: cetteSemaine.nombreActionsDemarchesARealiser,
  );
}

AccueilItem? _prochainRendezvousItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _evenementsItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _alertesItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _favorisItem(AccueilSuccessState successState) {
  return null;
}

AccueilItem? _outilsItem(AccueilSuccessState successState) {
  return null;
}

abstract class AccueilItem extends Equatable {
  @override
  List<Object?> get props => [];
}

//TODO: move: 1 file / item

class AccueilCetteSemaineItem extends AccueilItem {
  final String rendezVous;
  final String actionsDemarchesEnRetard;
  final String actionsDemarchesARealiser;

  AccueilCetteSemaineItem({
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
  List<Object?> get props => [rendezVous, actionsDemarchesEnRetard, actionsDemarchesARealiser];
}

class AccueilProchainRendezvousItem extends AccueilItem {}

class AccueilEvenementsItem extends AccueilItem {}

class AccueilAlertesItem extends AccueilItem {}

class AccueilFavorisItem extends AccueilItem {}

class AccueilOutilsItem extends AccueilItem {}
