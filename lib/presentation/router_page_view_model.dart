import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/cgu/cgu_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:redux/redux.dart';

enum RouterPageDisplayState { splash, onboarding, login, cgu, main, tutorial }

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
  final onboardingState = store.state.firstLaunchOnboardingState;
  final cguState = store.state.cguState;

  if (loginState is LoginNotInitializedState || onboardingState is FirstLaunchOnboardingNotInitializedState) {
    return RouterPageDisplayState.splash;
  }

  if (loginState is LoginSuccessState) {
    if (cguState is CguNeverAcceptedState || cguState is CguUpdateRequiredState) {
      return RouterPageDisplayState.cgu;
    } else if (tutoState is ShowTutorialState) {
      return RouterPageDisplayState.tutorial;
    } else {
      return RouterPageDisplayState.main;
    }
  }

  if (onboardingState is FirstLaunchOnboardingSuccessState && onboardingState.showOnboarding) {
    return RouterPageDisplayState.onboarding;
  }

  return RouterPageDisplayState.login;
}

MainPageDisplayState _toMainPageDisplayState(Store<AppState> store) {
  final deepLink = store.getDeepLink();
  if (deepLink != null) {
    return _toMainPageDisplayStateByDeepLink(deepLink);
  }
  return MainPageDisplayState.accueil;
}

MainPageDisplayState _toMainPageDisplayStateByDeepLink(DeepLink deepLink) {
  return switch (deepLink) {
    ActualisationPeDeepLink() => MainPageDisplayState.actualisationPoleEmploi,
    MonSuiviDeepLink() => MainPageDisplayState.monSuivi,
    NouveauMessageDeepLink() => MainPageDisplayState.chat,
    EventListDeepLink() => MainPageDisplayState.evenements,
    RechercheDeepLink() => MainPageDisplayState.solutionsRecherche,
    OutilsDeepLink() => MainPageDisplayState.solutionsOutils,
    _ => MainPageDisplayState.accueil,
  };
}
