import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:redux/redux.dart';

enum RouterPageDisplayState { SPLASH, LOGIN, MAIN, TUTORIAL }

class RouterPageViewModel extends Equatable {
  final RouterPageDisplayState routerPageDisplayState;
  final MainPageDisplayState mainPageDisplayState;
  final int deepLinkKey;
  final String? storeUrl;
  final Function() onAppStoreOpened;

  RouterPageViewModel({
    required this.routerPageDisplayState,
    required this.mainPageDisplayState,
    required this.deepLinkKey,
    required this.storeUrl,
    required this.onAppStoreOpened,
  });

  static RouterPageViewModel create(Store<AppState> store, Platform platform) {
    return RouterPageViewModel(
      routerPageDisplayState: _routerPageDisplayState(store),
      mainPageDisplayState: _toMainPageDisplayState(store),
      deepLinkKey: store.state.deepLinkState.deepLinkOpenedAt.hashCode,
      storeUrl: _storeUrl(store, platform),
      onAppStoreOpened: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [mainPageDisplayState, routerPageDisplayState, deepLinkKey];
}

String? _storeUrl(Store<AppState> store, Platform platform) {
  final Brand brand = store.state.configurationState.configuration?.brand ?? Brand.brand;
  final lastVersion = store.getDeepLinkAs<NouvellesFonctionnalitesDeepLink>()?.lastVersion;
  if (lastVersion != null) {
    final appVersion = store.state.configurationState.configuration?.version;
    if (appVersion != null && appVersion < lastVersion) {
      return platform.getAppStoreUrl(brand);
    }
  }
  return null;
}

RouterPageDisplayState _routerPageDisplayState(Store<AppState> store) {
  final loginState = store.state.loginState;
  final tutoState = store.state.tutorialState;
  if (loginState is LoginNotInitializedState) return RouterPageDisplayState.SPLASH;
  if (loginState is LoginSuccessState) {
    if (tutoState is ShowTutorialState) {
      return RouterPageDisplayState.TUTORIAL;
    } else {
      return RouterPageDisplayState.MAIN;
    }
  }
  return RouterPageDisplayState.LOGIN;
}

MainPageDisplayState _toMainPageDisplayState(Store<AppState> store) {
  final deepLink = store.getDeepLink();
  if (deepLink != null) {
    return _toMainPageDisplayStateByDeepLink(deepLink);
  }
  return MainPageDisplayState.DEFAULT;
}

MainPageDisplayState _toMainPageDisplayStateByDeepLink(DeepLink deepLink) {
  if (deepLink is AgendaDeepLink) return MainPageDisplayState.AGENDA_TAB;
  if (deepLink is DetailActionDeepLink) return MainPageDisplayState.ACTIONS_TAB;
  if (deepLink is DetailRendezvousDeepLink) return MainPageDisplayState.RENDEZVOUS_TAB;
  if (deepLink is DetailSessionMiloDeepLink) return MainPageDisplayState.RENDEZVOUS_TAB;
  if (deepLink is NouveauMessageDeepLink) return MainPageDisplayState.CHAT;
  if (deepLink is FavorisDeepLink) return MainPageDisplayState.FAVORIS;
  if (deepLink is AlerteDeepLink) return MainPageDisplayState.ALERTE;
  if (deepLink is AlertesDeepLink) return MainPageDisplayState.ALERTES;
  if (deepLink is EventListDeepLink) return MainPageDisplayState.EVENT_LIST;
  if (deepLink is ActualisationPeDeepLink) return MainPageDisplayState.ACTUALISATION_PE;
  if (deepLink is RechercheDeepLink) return MainPageDisplayState.RECHERCHE;
  if (deepLink is OutilsDeepLink) return MainPageDisplayState.OUTILS;
  return MainPageDisplayState.DEFAULT;
}
