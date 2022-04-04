import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when rendezvous state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousLoadingState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is not initialized should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousNotInitializedState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is a failure should display failure', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousFailureState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  group('create when rendezvous state is success…', () {
    group('with rendezvous…', () {

      group('should display list', () {
        final rendezvous = [
          mockRendezvous(id: '1', date: DateTime(2021, 12, 23, 10, 20)),
          mockRendezvous(id: '2', date: DateTime(2021, 12, 24, 13, 40)),
        ];

        test('and sort them by chronological order for Pole Emploi', () {
          // Given
          final store = _loggedInPEStore(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.rendezvousIds, ['1', '2']);
        });

        test('and sort them by most recent for Mission Locale', () {
          // Given
          final store = _loggedInMiloStore(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.rendezvousIds, ['2', '1']);
        });
      });

      test('and coming from deeplink', () {
        // Given
        final store = TestStoreFactory().initializeReduxStore(
          initialState: loggedInState().copyWith(
            deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now(), '1'),
            rendezvousState: RendezvousSuccessState([mockRendezvous(id: '1')]),
          ),
        );

        // When
        final viewModel = RendezvousListViewModel.create(store);

        // Then
        expect(viewModel.deeplinkRendezvousId, '1');
      });

      test('and coming from deeplink but ID is not valid anymore', () {
        // Given
        final store = TestStoreFactory().initializeReduxStore(
          initialState: loggedInState().copyWith(
            deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now(), '1'),
            rendezvousState: RendezvousSuccessState([mockRendezvous(id: '2')]),
          ),
        );

        // When
        final viewModel = RendezvousListViewModel.create(store);

        // Then
        expect(viewModel.deeplinkRendezvousId, isNull);
      });
    });

    test('without rendezvous should display an empty content', () {
      // Given
      final store = _store([]);

      // When
      final viewModel = RendezvousListViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
      expect(viewModel.rendezvousIds.length, 0);
    });
  });

  test('onRetry should trigger RequestRendezvousAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = RendezvousListViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<RendezvousRequestAction>());
  });

  test('onDeeplinkUsed should trigger ResetDeeplinkAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = RendezvousListViewModel.create(store);

    // When
    viewModel.onDeeplinkUsed();

    // Then
    expect(store.dispatchedAction, isA<ResetDeeplinkAction>());
  });
}

Store<AppState> _store(List<Rendezvous> rendezvous) {
  return TestStoreFactory().initializeReduxStore(
    initialState: loggedInState().copyWith(
      rendezvousState: RendezvousSuccessState(rendezvous),
    ),
  );
}

Store<AppState> _loggedInPEStore(List<Rendezvous> rendezvous) {
  return TestStoreFactory().initializeReduxStore(
    initialState: loggedInPoleEmploiState().copyWith(
      rendezvousState: RendezvousSuccessState(rendezvous),
    ),
  );
}

Store<AppState> _loggedInMiloStore(List<Rendezvous> rendezvous) {
  return TestStoreFactory().initializeReduxStore(
    initialState: loggedInMiloState().copyWith(
      rendezvousState: RendezvousSuccessState(rendezvous),
    ),
  );
}
