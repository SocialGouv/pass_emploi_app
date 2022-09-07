import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('Create MainPageViewModel when chat status state is…', () {
    test('not initialized should not display chat badge', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        chatStatusState: ChatStatusNotInitializedState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('empty should not display chat badge', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        chatStatusState: ChatStatusEmptyState(),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('success without unread message should not display chat badge', () {
      final state = AppState.initialState().copyWith(
        loginState: successMiloUserState(),
        chatStatusState: ChatStatusSuccessState(
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
        chatStatusState: ChatStatusSuccessState(
          unreadMessageCount: 1,
          lastConseillerReading: DateTime.now(),
        ),
      );
      final store = Store<AppState>(reducer, initialState: state);

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, true);
    });
  });

  group('Create MainPageViewModel when rating app state is…', () {
    test('not initialized should not show rating banner', () {
      // Given
      final store = givenState().dontShowRating().store();

      // When
      final viewModel = MainPageViewModel.create(store);

      // Then
      expect(viewModel.showRating, isFalse);
    });

    test('success should show rating banner', () {
      // Given
      final store = givenState().showRating().store();

      // When
      final viewModel = MainPageViewModel.create(store);

      // Then
      expect(viewModel.showRating, isTrue);
    });
  });
}
