import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:redux/redux.dart';

class AccueilViewModel extends Equatable {
  final DisplayState displayState;
  final List<AccueilItem> items;
  final DeepLink? deepLink;
  final Function() resetDeeplink;
  final Function() retry;

  AccueilViewModel({
    required this.displayState,
    required this.items,
    required this.deepLink,
    required this.resetDeeplink,
    required this.retry,
  });

  factory AccueilViewModel.create(Store<AppState> store) {
    return AccueilViewModel(
      displayState: _displayState(store),
      items: _items(store),
      deepLink: store.getDeepLink(),
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      retry: () => store.dispatch(AccueilRequestAction(forceRefresh: true)),
    );
  }

  @override
  List<Object?> get props => [displayState, items, deepLink];
}

DisplayState _displayState(Store<AppState> store) {
  return switch (store.state.accueilState) {
    AccueilSuccessState _ => DisplayState.contenu,
    AccueilFailureState _ => DisplayState.erreur,
    AccueilLoadingState _ || AccueilNotInitializedState _ => DisplayState.chargement,
  };
}

List<AccueilItem> _items(Store<AppState> store) {
  final accueilState = store.state.accueilState;
  final user = store.state.user();
  final brand = store.state.configurationState.getBrand();
  if (accueilState is! AccueilSuccessState || user == null) return [];

  return [
    _campagneItem(store.state),
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
  final prochaineSessionMilo = successState.accueil.prochaineSessionMilo;

  return switch ((prochainRendezVous?.date, prochaineSessionMilo?.dateDeDebut)) {
    (null, null) => null,
    (null, _) => AccueilProchaineSessionMiloItem(prochaineSessionMilo!.id),
    (_, null) => AccueilProchainRendezvousItem(prochainRendezVous!.id),
    (_, _) => prochainRendezVous!.date.isBefore(prochaineSessionMilo!.dateDeDebut)
        ? AccueilProchainRendezvousItem(prochainRendezVous.id)
        : AccueilProchaineSessionMiloItem(prochaineSessionMilo.id),
  };
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
  return switch (brand) {
    Brand.cej => AccueilOutilsItem([
        Outils.diagoriente.withoutImage(),
        Outils.aides.withoutImage(),
        Outils.benevolatCej.withoutImage(),
      ]),
    Brand.brsa => AccueilOutilsItem([
        Outils.emploiSolidaire.withoutImage(),
        Outils.emploiStore.withoutImage(),
        Outils.benevolatBrsa.withoutImage(),
      ]),
  };
}

AccueilItem? _campagneItem(AppState state) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return AccueilCampagneItem(titre: campagne.titre, description: campagne.description);
  }
  return null;
}
