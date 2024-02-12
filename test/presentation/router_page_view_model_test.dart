import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/presentation/router_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('RouterPageViewModel.create when login not initialized should display splash screen', () {
    Brand.setBrand(Brand.cej);
    final store = givenState().store();

    final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

    expect(viewModel.routerPageDisplayState, RouterPageDisplayState.SPLASH);
  });

  group("RouterPageViewModel.create when user not logged in…", () {
    test('…with not logged state in should display login page', () {
      final store = givenState().copyWith(loginState: UserNotLoggedInState()).store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });

    test('…with login loading state should display login page', () {
      final store = givenState().copyWith(loginState: LoginLoadingState()).store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });

    test('…with login failure state should display login page', () {
      final store = givenState().copyWith(loginState: LoginGenericFailureState('')).store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });
  });

  group("RouterPageViewModel.create when user logged in…", () {
    test('…and deep link not set should display main page with accueil display state', () {
      final store = givenState().loggedInUser().withDeepLink(NotInitializedDeepLinkState()).store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.accueil);
    });

    test('…and deep link is set to agenda should display main page with monSuivi display state', () {
      final store = givenState().loggedInUser().withHandleDeepLink(AgendaDeepLink()).store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.monSuivi);
    });

    test('…and deep link is set to rendezvous should display main page with accueil display state', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(RendezvousDeepLink('id'))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.accueil);
    });

    test('…and deep link is set to Detail Session Milo should display main page with accueil display state', () {
      final store = givenState().loggedInMiloUser().deeplinkToSessionMilo('1').store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.accueil);
    });

    test('…and deep link is set to action should display main page with accueil display state', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(ActionDeepLink('id'))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.accueil);
    });

    test('…and deep link is set to favoris should display main page with accueil display state', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(FavorisDeepLink())
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.accueil);
    });

    test('…and deep link is set to alertes should display main page with accueil display state', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(AlertesDeepLink())
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.accueil);
    });

    test('…and deep link is set to actualisation pole emploi should display main page with actualisation pole emploi',
        () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(ActualisationPeDeepLink())
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.mainPageDisplayState, MainPageDisplayState.actualisationPoleEmploi);
    });

    test('…and deep link is set to chat should display main page with chat display state', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(NouveauMessageDeepLink())
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.chat);
    });

    test('…and deep link is set to recherche should display main page with recherche', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(RechercheDeepLink())
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.mainPageDisplayState, MainPageDisplayState.solutionsRecherche);
    });

    test('…and deep link is set to outils should display main page with outils', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(OutilsDeepLink())
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.mainPageDisplayState, MainPageDisplayState.solutionsOutils);
    });

    test('…and deep link is set to event list should display main page with event list display state', () {
      final store = givenState() //
          .loggedInUser()
          .withHandleDeepLink(EventListDeepLink())
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.evenements);
    });

    test('should show tutorial if user did not read it yet', () {
      final store = givenState() //
          .loggedInUser()
          .copyWith(tutorialState: ShowTutorialState(Tutorial.milo))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.IOS);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.TUTORIAL);
    });
  });

  group("RouterPageViewModel.create when user comes from deep link", () {
    test("it does nothing when the version is same", () {
      final store = givenState(configuration(version: Version(1, 0, 0)))
          .withHandleDeepLink(NouvellesFonctionnalitesDeepLink(lastVersion: Version(1, 0, 0)))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.storeUrl, isNull);
    });

    test("it does nothing when the version is greater", () {
      final store = givenState(configuration(version: Version(1, 2, 3)))
          .withHandleDeepLink(NouvellesFonctionnalitesDeepLink(lastVersion: Version(1, 0, 0)))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.storeUrl, isNull);
    });

    test("it redirect to the android store when the version is too old", () {
      final store = givenState(configuration(version: Version(1, 0, 0)))
          .withHandleDeepLink(NouvellesFonctionnalitesDeepLink(lastVersion: Version(2, 1, 2)))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.storeUrl, 'market://details?id=fr.fabrique.social.gouv.passemploi');
    });

    test("it redirect to the ios store when the version is too old", () {
      final store = givenState(configuration(version: Version(1, 0, 0)))
          .withHandleDeepLink(NouvellesFonctionnalitesDeepLink(lastVersion: Version(2, 1, 2)))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.IOS);

      expect(viewModel.storeUrl, 'itms-apps://itunes.apple.com/app/apple-store/id1581603519');
    });

    test("on app store opened, it resets the deeplink state", () {
      final store = StoreSpy();
      final viewModel = RouterPageViewModel.create(store, Platform.IOS);

      // When
      viewModel.onAppStoreOpened();

      // Then
      expect(store.dispatchedAction, isA<ResetDeeplinkAction>());
    });
  });

  test('2 RouterPageViewModel with same login states and deep link state should be equal', () {
    withClock(Clock.fixed(DateTime(2022)), () {
      final state1 = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: HandleDeepLinkState(NouveauMessageDeepLink(), DeepLinkOrigin.pushNotification),
      );
      final store1 = Store<AppState>(reducer, initialState: state1);

      final state2 = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: HandleDeepLinkState(NouveauMessageDeepLink(), DeepLinkOrigin.pushNotification),
      );
      final store2 = Store<AppState>(reducer, initialState: state2);

      final viewModel1 = RouterPageViewModel.create(store1, Platform.ANDROID);
      final viewModel2 = RouterPageViewModel.create(store2, Platform.ANDROID);

      expect(viewModel1 == viewModel2, true);
    });
  });

  test('2 RouterPageViewModel with same login states and different deep link should be different', () {
    final state1 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: HandleDeepLinkState(NouveauMessageDeepLink(), DeepLinkOrigin.pushNotification),
    );
    final store1 = Store<AppState>(reducer, initialState: state1);

    final state2 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: HandleDeepLinkState(ActionDeepLink('id'), DeepLinkOrigin.pushNotification),
    );
    final store2 = Store<AppState>(reducer, initialState: state2);

    final viewModel1 = RouterPageViewModel.create(store1, Platform.ANDROID);
    final viewModel2 = RouterPageViewModel.create(store2, Platform.ANDROID);

    expect(viewModel1 == viewModel2, false);
  });

  test(
      '2 RouterPageViewModel with same login states and same deep link but different deep link date should be different',
      () {
    final state1 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: HandleDeepLinkState(NouveauMessageDeepLink(), DeepLinkOrigin.pushNotification),
    );
    final store1 = Store<AppState>(reducer, initialState: state1);

    final state2 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: HandleDeepLinkState(NouveauMessageDeepLink(), DeepLinkOrigin.pushNotification),
    );
    final store2 = Store<AppState>(reducer, initialState: state2);

    final viewModel1 = RouterPageViewModel.create(store1, Platform.ANDROID);
    final viewModel2 = RouterPageViewModel.create(store2, Platform.ANDROID);

    expect(viewModel1 == viewModel2, false);
  });
}
