import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/presentation/router_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

void main() {
  test('RouterPageViewModel.create when login not initialized should display splash screen', () {
    final state = AppState.initialState().copyWith(loginState: State<User>.notInitialized());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = RouterPageViewModel.create(store);

    expect(viewModel.routerPageDisplayState, RouterPageDisplayState.SPLASH);
  });

  group("RouterPageViewModel.create when user not logged in…", () {
    test('…with not logged state in should display login page', () {
      final state = AppState.initialState().copyWith(loginState: State<User>.failure());
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });

    test('…with login loading state should display login page', () {
      final state = AppState.initialState().copyWith(loginState: State<User>.loading());
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });

    test('…with login failure state should display login page', () {
      final state = AppState.initialState().copyWith(loginState: State<User>.failure());
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.LOGIN);
    });
  });

  group("RouterPageViewModel.create when user logged in…", () {
    test('via Pole Emploi should redirect to Search Page', () {
      final state = AppState.initialState().copyWith(loginState: successPoleEmploiUserState());
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.SEARCH);
    });

    test('…and deep link not set should display main page with default display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: DeepLinkState(DeepLink.NOT_SET, DateTime.now()),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.DEFAULT);
    });

    test('…and deep link is set to rendezvous should display main page with rendezvous display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now()),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.RENDEZVOUS_TAB);
    });

    test('…and deep link is set to actions should display main page with actions display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_ACTION, DateTime.now()),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.ACTIONS_TAB);
    });

    test('…and deep link is set to chat should display main page with chat display state', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.now()),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = RouterPageViewModel.create(store);

      expect(viewModel.routerPageDisplayState, RouterPageDisplayState.MAIN);
      expect(viewModel.mainPageDisplayState, MainPageDisplayState.CHAT);
    });
  });

  test('2 RouterPageViewModel with same login states and deep link state should be equal', () {
    final state1 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.utc(2022, 10, 24, 11, 56, 50, 330)),
    );
    final store1 = Store<AppState>(reducer, initialState: state1);

    final state2 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.utc(2022, 10, 24, 11, 56, 50, 330)),
    );
    final store2 = Store<AppState>(reducer, initialState: state2);

    final viewModel1 = RouterPageViewModel.create(store1);
    final viewModel2 = RouterPageViewModel.create(store2);

    expect(viewModel1 == viewModel2, true);
  });

  test('2 RouterPageViewModel with same login states and different deep link should be different', () {
    final state1 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.utc(2022, 10, 24, 11, 56, 50, 330)),
    );
    final store1 = Store<AppState>(reducer, initialState: state1);

    final state2 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_ACTION, DateTime.utc(2022, 10, 24, 11, 56, 50, 330)),
    );
    final store2 = Store<AppState>(reducer, initialState: state2);

    final viewModel1 = RouterPageViewModel.create(store1);
    final viewModel2 = RouterPageViewModel.create(store2);

    expect(viewModel1 == viewModel2, false);
  });

  test(
      '2 RouterPageViewModel with same login states and same deep link but different deep link date should be different',
      () {
    final state1 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.utc(2022, 10, 24, 11, 56, 50, 330)),
    );
    final store1 = Store<AppState>(reducer, initialState: state1);

    final state2 = AppState.initialState().copyWith(
      loginState: successMiloUserState(),
      deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.utc(2023, 10, 24, 11, 56, 50, 330)),
    );
    final store2 = Store<AppState>(reducer, initialState: state2);

    final viewModel1 = RouterPageViewModel.create(store1);
    final viewModel2 = RouterPageViewModel.create(store2);

    expect(viewModel1 == viewModel2, false);
  });
}
