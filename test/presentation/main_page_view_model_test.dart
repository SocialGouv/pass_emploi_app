import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';

import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('Create MainPageViewModel when chat status state is…', () {
    test('not initialized should not display chat badge', () {
      final store = givenState() //
          .loggedInMiloUser()
          .copyWith(chatStatusState: ChatStatusNotInitializedState())
          .store();

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('empty should not display chat badge', () {
      final store = givenState() //
          .loggedInMiloUser()
          .copyWith(chatStatusState: ChatStatusEmptyState())
          .store();

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('success without unread message should not display chat badge', () {
      final store = givenState() //
          .loggedInMiloUser()
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime.now(),
            ),
          )
          .store();

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, false);
    });

    test('success with unread message should display chat badge', () {
      final store = givenState() //
          .loggedInMiloUser()
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: true,
              lastConseillerReading: DateTime.now(),
            ),
          )
          .store();

      final viewModel = MainPageViewModel.create(store);

      expect(viewModel.withChatBadge, true);
    });
  });

  group('Create MainPageViewModel when user is...', () {
    test('pole emploi', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();
      // When
      final viewModel = MainPageViewModel.create(store);
      // Then
      expect(viewModel.tabs, [
        MainTab.accueil,
        MainTab.monSuivi,
        MainTab.chat,
        MainTab.solutions,
        MainTab.evenements,
      ]);
    });

    test('milo', () {
      // Given
      final store = givenState().loggedInMiloUser().store();
      // When
      final viewModel = MainPageViewModel.create(store);
      // Then
      expect(viewModel.tabs, [
        MainTab.accueil,
        MainTab.monSuivi,
        MainTab.chat,
        MainTab.solutions,
        MainTab.evenements,
      ]);
    });
  });

  group('Create MainPageViewModel loginMode when user is...', () {
    test('pole emploi', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();
      // When
      final viewModel = MainPageViewModel.create(store);
      // Then
      expect(viewModel.loginMode, LoginMode.POLE_EMPLOI);
    });

    test('milo', () {
      // Given
      final store = givenState().loggedInMiloUser().store();
      // When
      final viewModel = MainPageViewModel.create(store);
      // Then
      expect(viewModel.loginMode, LoginMode.MILO);
    });
  });

  group('useCvm', () {
    test('when feature flip state is set to false', () {
      // Given
      final store = givenState().store();

      // When
      final viewModel = MainPageViewModel.create(store);

      // Then
      expect(viewModel.useCvm, isFalse);
    });

    test('when feature flip state is set to true', () {
      // Given
      final store = givenState().withFeatureFlip(useCvm: true).store();

      // When
      final viewModel = MainPageViewModel.create(store);

      // Then
      expect(viewModel.useCvm, isTrue);
    });
  });

  test('resetDeeplink should trigger ResetDeeplinkAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = MainPageViewModel.create(store);

    // When
    viewModel.resetDeeplink();

    // Then
    expect(store.dispatchedAction, isA<ResetDeeplinkAction>());
  });
}
