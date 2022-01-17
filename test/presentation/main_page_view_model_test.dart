import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

void main() {
  group('Create MainPageViewModel when chat status state is…', () {
    test('not initialized should not display chat badge', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        chatStatusState: ChatStatusState.notInitialized(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('empty should not display chat badge', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        chatStatusState: ChatStatusState.empty(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('success without unread message should not display chat badge', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        chatStatusState: ChatStatusState.success(
          unreadMessageCount: 0,
          lastConseillerReading: DateTime.now(),
        ),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('success with unread message should display chat badge', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        chatStatusState: ChatStatusState.success(
          unreadMessageCount: 1,
          lastConseillerReading: DateTime.now(),
        ),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, true);
    });
  });

  group('Create MainPageViewModel when user logged in…', () {
    test('via Pôle Emploi should set isPoleEmploiLogin to true', () {
      final state = AppState.initialState().copyWith(
        loginState: successPoleEmploiUserState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.isPoleEmploiLogin, true);
    });

    test('via Pass Emploi should set isPoleEmploiLogin to false', () {
      final state = AppState.initialState().copyWith(
        loginState: successPassEmploiUserState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.isPoleEmploiLogin, false);
    });

    test('via Milo should set isPoleEmploiLogin to false', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.isPoleEmploiLogin, false);
    });
  });
}
