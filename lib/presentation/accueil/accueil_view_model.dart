import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_state.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/features/remote_campagne_accueil/remote_campagne_accueil_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/models/user.dart';
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
  final bool shouldShowNavigationBottomSheet;
  final bool withNewNotifications;
  final Function() resetDeeplink;
  final Function() retry;

  AccueilViewModel({
    required this.displayState,
    required this.items,
    required this.deepLink,
    required this.shouldResetDeeplink,
    required this.shouldShowOnboarding,
    required this.shouldShowNavigationBottomSheet,
    required this.withNewNotifications,
    required this.resetDeeplink,
    required this.retry,
  });

  factory AccueilViewModel.create(Store<AppState> store) {
    return AccueilViewModel(
      displayState: _displayState(store),
      items: _items(store),
      deepLink: store.getDeepLink(),
      shouldResetDeeplink: _shouldResetDeeplink(store),
      shouldShowOnboarding: _shouldShowOnboarding(store),
      shouldShowNavigationBottomSheet: _shouldShowNavigationBottomSheet(store),
      withNewNotifications: _withNewNotifications(store),
      resetDeeplink: () => store.dispatch(ResetDeeplinkAction()),
      retry: () => store.dispatch(AccueilRequestAction(forceRefresh: true)),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        items,
        deepLink,
        shouldShowOnboarding,
        shouldShowNavigationBottomSheet,
        withNewNotifications,
      ];
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
    ..._remoteCampagneAccueilItems(store, store.state),
    _ratingAppItem(store.state),
    _campagneRecrutementItem(store, store.state),
    _campagneEvaluationItem(store.state),
    _cetteSemaineItem(user, accueilState),
    _prochainRendezvousItem(user, accueilState),
    _favorisItem(accueilState),
    _evenementsItem(accueilState),
    _alertesItem(accueilState),
    _outilsItem(accueilState, user.accompagnement),
  ].whereNotNull().toList();
}

AccueilItem? _cetteSemaineItem(User user, AccueilSuccessState successState) {
  if (user.accompagnement == Accompagnement.avenirPro) return null;
  final cetteSemaine = successState.accueil.cetteSemaine;
  if (cetteSemaine == null) return null;
  final bool withRendezvousCount =
      user.accompagnement != Accompagnement.rsaConseilsDepartementaux || cetteSemaine.nombreRendezVous != 0;

  return AccueilCetteSemaineItem.from(
    loginMode: user.loginMode,
    rendezvousCount: withRendezvousCount ? cetteSemaine.nombreRendezVous : null,
    actionsOuDemarchesCount: cetteSemaine.nombreActionsDemarchesARealiser,
  );
}

AccueilItem? _prochainRendezvousItem(User user, AccueilSuccessState successState) {
  if (user.accompagnement == Accompagnement.avenirPro) return null;
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
    Accompagnement.rsaFranceTravail || Accompagnement.rsaConseilsDepartementaux => AccueilOutilsItem([
        Outil.mesAidesFt.withoutImage(),
        Outil.emploiSolidaire.withoutImage(),
        Outil.emploiStore.withoutImage(),
      ]),
    Accompagnement.avenirPro || Accompagnement.aij => AccueilOutilsItem([
        Outil.mesAidesFt.withoutImage(),
        Outil.benevolatPassEmploi.withoutImage(),
        Outil.formation.withoutImage(),
      ]),
  };
}

List<AccueilItem?> _remoteCampagneAccueilItems(Store<AppState> store, AppState state) {
  final brand = state.configurationState.configuration?.brand;
  final accompagnement = state.user()?.accompagnement;

  return state.remoteCampagneAccueilState.campagnes.map((campagne) {
    if (campagne.brand != null && campagne.brand != brand) return null;
    if (!campagne.accompagnements.contains(accompagnement)) return null;
    if (!campagne.isActive) return null;
    return RemoteCampagneAccueilItem(
      title: campagne.title,
      cta: campagne.cta,
      url: campagne.url,
      onDismissed: () => store.dispatch(RemoteCampagneAccueilDismissAction(campagne.id)),
    );
  }).toList();
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

bool _shouldShowOnboarding(Store<AppState> store) {
  return store.state.onboardingState.showAccueilOnboarding;
}

bool _shouldShowNavigationBottomSheet(Store<AppState> store) {
  final accueilState = store.state.accueilState;
  final user = store.state.user();
  if (accueilState is! AccueilSuccessState || user == null) return false;
  return user.accompagnement != Accompagnement.avenirPro;
}

bool _withNewNotifications(Store<AppState> store) {
  final inAppNotificationsState = store.state.inAppNotificationsState;
  final dateDerniereConsultation = store.state.dateConsultationNotificationState.date;

  if (inAppNotificationsState is! InAppNotificationsSuccessState) {
    return false;
  }

  final notification = inAppNotificationsState.notifications.firstOrNull;

  if (notification == null) {
    return false;
  }

  final isNew = dateDerniereConsultation != null ? notification.date.isAfter(dateDerniereConsultation) : true;
  return isNew;
}
