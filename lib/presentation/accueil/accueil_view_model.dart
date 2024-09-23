import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/iterable_extensions.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:redux/redux.dart';

class AccueilViewModel extends Equatable {
  final DisplayState displayState;
  final List<AccueilItem> items;
  final DeepLink? deepLink;
  final bool shouldResetDeeplink;
  final bool shouldShowOnboarding;
  final Function() resetDeeplink;
  final Function() retry;

  AccueilViewModel({
    required this.displayState,
    required this.items,
    required this.deepLink,
    required this.shouldResetDeeplink,
    required this.shouldShowOnboarding,
    required this.resetDeeplink,
    required this.retry,
  });

  factory AccueilViewModel.create(Store<AppState> store, {bool releaseMode = true}) {
    return AccueilViewModel(
      displayState: _displayState(store),
      items: _items(store),
      deepLink: store.getDeepLink(),
      shouldResetDeeplink: _shouldResetDeeplink(store),
      shouldShowOnboarding: _shouldShowOnboarding(store, releaseMode),
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      retry: () => store.dispatch(AccueilRequestAction(forceRefresh: true)),
    );
  }

  @override
  List<Object?> get props => [displayState, items, deepLink, shouldShowOnboarding];
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
    RappelCreationDemarcheDeepLink() => false,
    RappelCreationActionDeepLink() => false,
    _ => true,
  };
}

List<AccueilItem> _items(Store<AppState> store) {
  final accueilState = store.state.accueilState;
  final user = store.state.user();
  if (accueilState is! AccueilSuccessState || user == null) return [];

  return [
    _ratingAppItem(store.state),
    _campagneRecrutementItem(store, store.state),
    _campagneEvaluationItem(store.state),
    _cetteSemaineItem(user.loginMode, accueilState),
    _prochainRendezvousItem(accueilState),
    _evenementsItem(accueilState),
    _alertesItem(accueilState),
    _favorisItem(accueilState),
    _outilsItem(accueilState, user.accompagnement),
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

AccueilItem? _outilsItem(AccueilSuccessState successState, Accompagnement accompagnement) {
  return switch (accompagnement) {
    Accompagnement.cej => AccueilOutilsItem([
        Outil.mesAidesFt.withoutImage(),
        Outil.benevolatCej.withoutImage(),
        Outil.formation.withoutImage(),
      ]),
    Accompagnement.rsaFranceTravail => AccueilOutilsItem([
        Outil.mesAidesFt.withoutImage(),
        Outil.emploiSolidaire.withoutImage(),
        Outil.emploiStore.withoutImage(),
      ]),
    Accompagnement.aij => AccueilOutilsItem([
        Outil.mesAidesFt.withoutImage(),
        Outil.benevolatPassEmploi.withoutImage(),
        Outil.formation.withoutImage(),
      ]),
  };
}

AccueilItem? _ratingAppItem(AppState state) {
  return state.ratingState is ShowRatingState ? RatingAppItem() : null;
}

AccueilItem? _campagneEvaluationItem(AppState state) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return CampagneEvaluationItem(titre: campagne.titre, description: campagne.description);
  }
  return null;
}

AccueilItem? _campagneRecrutementItem(Store<AppState> store, AppState state) {
  if (state.featureFlipState.featureFlip.withCampagneRecrutement) {
    return CampagneRecrutementItem(onDismiss: () => store.dispatch(CampagneRecrutementDismissAction()));
  }
  return null;
}

bool _shouldShowOnboarding(Store<AppState> store, bool releaseMode) {
  return releaseMode && store.state.onboardingState.showAccueilOnboarding;
}
