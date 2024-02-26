import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:redux/redux.dart';

class AccueilViewModel extends Equatable {
  final DisplayState displayState;
  final List<AccueilItem> items;
  final DeepLink? deepLink;
  final bool shouldResetDeeplink;
  final Function() resetDeeplink;
  final Function() retry;

  AccueilViewModel({
    required this.displayState,
    required this.items,
    required this.deepLink,
    required this.shouldResetDeeplink,
    required this.resetDeeplink,
    required this.retry,
  });

  factory AccueilViewModel.create(Store<AppState> store) {
    return AccueilViewModel(
      displayState: _displayState(store),
      items: _items(store),
      deepLink: store.getDeepLink(),
      shouldResetDeeplink: _shouldResetDeeplink(store),
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      retry: () => store.dispatch(AccueilRequestAction(forceRefresh: true)),
    );
  }

  @override
  List<Object?> get props => [displayState, items, deepLink];
}

DisplayState _displayState(Store<AppState> store) {
  return switch (store.state.accueilState) {
    AccueilSuccessState _ => DisplayState.CONTENT,
    AccueilFailureState _ => DisplayState.FAILURE,
    AccueilLoadingState _ || AccueilNotInitializedState _ => DisplayState.LOADING,
  };
}

bool _shouldResetDeeplink(Store<AppState> store) {
  final deeplinkState = store.state.deepLinkState;
  if (deeplinkState is! HandleDeepLinkState) return false;

  return switch (deeplinkState.deepLink) {
    AlerteDeepLink() => false,
    _ => true,
  };
}

List<AccueilItem> _items(Store<AppState> store) {
  final accueilState = store.state.accueilState;
  final user = store.state.user();
  final brand = store.state.configurationState.getBrand();
  if (accueilState is! AccueilSuccessState || user == null) return [];

  return [
    _campagneRecrutementCej(store, store.state),
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
    rendezvousCount: cetteSemaine.nombreRendezVous,
    actionsOuDemarchesCount: cetteSemaine.nombreActionsDemarchesARealiser,
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
  final animations = successState.accueil.animationsCollectives
      .orEmpty()
      .map((e) => (e.id, e.date, AccueilEvenementsType.animationCollective))
      .toList();
  final sessions = successState.accueil.sessionsMiloAVenir
      .orEmpty()
      .map((e) => (e.id, e.dateDeDebut, AccueilEvenementsType.sessionMilo))
      .toList();

  final events = [
    ...animations,
    ...sessions,
  ].sorted((a, b) => a.$2.compareTo(b.$2)).take(3).map((e) => (e.$1, e.$3)).toList();

  return events.isNotEmpty ? AccueilEvenementsItem(events) : null;
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

CampagneRecrutementCej? _campagneRecrutementCej(Store<AppState> store, AppState state) {
  final isCej = Brand.isCej();
  final campagneRecrutementState = state.campagneRecrutementState;
  if (isCej && campagneRecrutementState.shouldShowCampagneRecrutement) {
    return CampagneRecrutementCej(onDismiss: () => store.dispatch(CampagneRecrutementDismissAction()));
  }
  return null;
}
