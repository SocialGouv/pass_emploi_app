import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/platform.dart';
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
      mainPageDisplayState: _toMainPageDisplayState(store.state.deepLinkState, store),
      deepLinkKey: store.state.deepLinkState.deepLinkOpenedAt.hashCode,
      storeUrl: _storeUrl(store.state, platform),
      onAppStoreOpened: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [mainPageDisplayState, routerPageDisplayState, deepLinkKey];
}

String? _storeUrl(AppState state, Platform platform) {
  final DeepLinkState deepLinkState = state.deepLinkState;
  if (deepLinkState is NouvellesFonctionnalitesDeepLinkState && deepLinkState.lastVersion != null) {
    final appVersion = state.configurationState.configuration?.version;
    if (appVersion != null && appVersion < deepLinkState.lastVersion!) {
      return platform.getAppStoreUrl();
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

MainPageDisplayState _toMainPageDisplayState(DeepLinkState deepLinkState, Store<AppState> store) {
  if (deepLinkState is! NotInitializedDeepLinkState) {
    return _toMainPageDisplayStateByDeepLink(deepLinkState);
  }
  final loginState = store.state.loginState;
  if (loginState is LoginSuccessState && loginState.user.loginMode == LoginMode.POLE_EMPLOI) {
    return MainPageDisplayState.ACTIONS_TAB;
  }
  return MainPageDisplayState.DEFAULT;
}

MainPageDisplayState _toMainPageDisplayStateByDeepLink(DeepLinkState state) {
  if (state is DetailActionDeepLinkState) return MainPageDisplayState.ACTIONS_TAB;
  if (state is DetailRendezvousDeepLinkState) return MainPageDisplayState.RENDEZVOUS_TAB;
  if (state is NouveauMessageDeepLinkState) return MainPageDisplayState.CHAT;
  if (state is SavedSearchDeepLinkState) return MainPageDisplayState.SAVED_SEARCH;
  return MainPageDisplayState.DEFAULT;
}
