import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_alertes_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_cette_semaine_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_evenements_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_favoris_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_outils_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_prochain_rendezvous_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';
import 'package:redux/redux.dart';

class AccueilViewModel extends Equatable {
  final DisplayState displayState;
  final List<AccueilItem> items;
  final DeepLinkState deepLinkState;
  final Function() resetDeeplink;
  final Function() retry;

  AccueilViewModel({
    required this.displayState,
    required this.items,
    required this.deepLinkState,
    required this.resetDeeplink,
    required this.retry,
  });

  factory AccueilViewModel.create(Store<AppState> store) {
    return AccueilViewModel(
      displayState: _displayState(store),
      items: _items(store),
      deepLinkState: store.state.deepLinkState,
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      retry: () => store.dispatch(AccueilRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items, deepLinkState];
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
  final brand = store.state.configurationState.getBrand();
  if (accueilState is! AccueilSuccessState || user == null) return [];

  return [
    _cetteSemaineItem(user.loginMode, accueilState),
    _prochainRendezvousItem(accueilState),
    _evenementsItem(accueilState),
    _alertesItem(accueilState),
    _favorisItem(accueilState),
    _outilsItem(accueilState, brand),
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
  final prochainRendezVous = successState.accueil.prochainRendezVous;
  return prochainRendezVous != null ? AccueilProchainRendezvousItem(prochainRendezVous.id) : null;
}

AccueilItem? _evenementsItem(AccueilSuccessState successState) {
  final evenements = successState.accueil.evenements;
  return evenements != null && evenements.isNotEmpty
      ? AccueilEvenementsItem(evenements.map((e) => e.id).toList())
      : null;
}

AccueilItem? _alertesItem(AccueilSuccessState successState) {
  final alertes = successState.accueil.alertes;
  return alertes != null ? AccueilAlertesItem(alertes) : null;
}

AccueilItem? _favorisItem(AccueilSuccessState successState) {
  final favoris = successState.accueil.favoris;
  return favoris != null ? AccueilFavorisItem(favoris) : null;
}

AccueilItem? _outilsItem(AccueilSuccessState successState, Brand brand) {
  switch (brand) {
    case Brand.cej:
      return AccueilOutilsItem([Outils.diagoriente.withoutImage(), Outils.aides.withoutImage()]);
    case Brand.brsa:
      return AccueilOutilsItem([Outils.emploiSolidaire.withoutImage(), Outils.emploiStore.withoutImage()]);
  }
}

abstract class AccueilItem extends Equatable {
  @override
  List<Object?> get props => [];
}

enum MonSuiviType { actions, demarches }
