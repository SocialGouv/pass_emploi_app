import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
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
    final state = AppState.initialState().copyWith(loginState: LoginNotInitializedState());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

    expect(viewModel.routerPageDisplayState, RouterPageDisplayState.SPLASH);
  });

  group("RouterPageViewModel.create when user not logged in…", () {
    test('…with not logged state in should display login page', () {
      final state = AppState.initialState().copyWith(loginState: LoginFailureState());
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });

    test('…with login loading state should display login page', () {
      final state = AppState.initialState().copyWith(loginState: LoginLoadingState());
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });

    test('…with login failure state should display login page', () {
      final state = AppState.initialState().copyWith(loginState: LoginFailureState());
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });
  });

  group("RouterPageViewModel.create when user logged in…", () {
    test('…and deep link not set should display main page with default display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: NotInitializedDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.DEFAULT);
    });

    test('…and deep link is set to rendezvous should display main page with agenda display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: AgendaDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.AGENDA_TAB);
    });

    test('…and deep link is set to rendezvous should display main page with rendezvous display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: DetailRendezvousDeepLinkState(idRendezvous: null),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.RENDEZVOUS_TAB);
    });

    test('…and deep link is set to actions should display main page with actions display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: DetailActionDeepLinkState(idAction: null),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.ACTIONS_TAB);
    });

    test('…and deep link is set to chat should display main page with chat display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: NouveauMessageDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.CHAT);
    });

    test('…and deep link is set to event list should display main page with event list display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: EventListDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.EVENT_LIST);
    });

    test('…and deep link is set to favoris should display main page with favoris display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: FavorisDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.FAVORIS);
    });

    test('…and deep link is set to saved searches should display main page with saved searches display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: SavedSearchesDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.SAVED_SEARCHES);
    });

    test('…and deep link is set to actualisation pole emploi should display main page with actualisation pole emploi',
        () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: ActualisationPeDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.mainPageDisplayState, MainPageDisplayState.ACTUALISATION_PE);
    });

    test('…and deep link is set to recherche should display main page with recherche', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: RechercheDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.mainPageDisplayState, MainPageDisplayState.RECHERCHE);
    });

    test('…and deep link is set to outils should display main page with outils', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: OutilsDeepLinkState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.mainPageDisplayState, MainPageDisplayState.OUTILS);
    });

    test('should show tutorial if user didn`t read it yet', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        tutorialState: ShowTutorialState(Tutorial.milo),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store, Platform.IOS);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.TUTORIAL);
    });
  });

  group("RouterPageViewModel.create when user comes from deep link", () {
    test("it does nothing when the version is same", () {
      final store = givenState(configuration(version: Version(1, 0, 0)))
          .deepLink(NouvellesFonctionnalitesDeepLinkState(lastVersion: Version(1, 0, 0)))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.storeUrl, isNull);
    });

    test("it does nothing when the version is greater", () {
      final store = givenState(configuration(version: Version(1, 2, 3)))
          .deepLink(NouvellesFonctionnalitesDeepLinkState(lastVersion: Version(1, 0, 0)))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.storeUrl, isNull);
    });

    test("it redirect to the android store when the version is too old", () {
      final store = givenState(configuration(version: Version(1, 0, 0)))
          .deepLink(NouvellesFonctionnalitesDeepLinkState(lastVersion: Version(2, 1, 2)))
          .store();

      final viewModel = RouterPageViewModel.create(store, Platform.ANDROID);

      expect(viewModel.storeUrl, 'market://details?id=fr.fabrique.social.gouv.passemploi');
    });

    test("it redirect to the ios store when the version is too old", () {
      final store = givenState(configuration(version: Version(1, 0, 0)))
          .deepLink(NouvellesFonctionnalitesDeepLinkState(lastVersion: Version(2, 1, 2)))
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
        deepLinkState: NouveauMessageDeepLinkState(),
      );
      final store1 = Store<AppState>(reducer, initialState: state1);

      final state2 = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: NouveauMessageDeepLinkState(),
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
      deepLinkState: NouveauMessageDeepLinkState(),
    );
    final store1 = Store<AppState>(reducer, initialState: state1);

    final state2 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: DetailActionDeepLinkState(idAction: 'id'),
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
      deepLinkState: NouveauMessageDeepLinkState(),
    );
    final store1 = Store<AppState>(reducer, initialState: state1);

    final state2 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: NouveauMessageDeepLinkState(),
    );
    final store2 = Store<AppState>(reducer, initialState: state2);

    final viewModel1 = RouterPageViewModel.create(store1, Platform.ANDROID);
    final viewModel2 = RouterPageViewModel.create(store2, Platform.ANDROID);

    expect(viewModel1 == viewModel2, false);
  });
}
