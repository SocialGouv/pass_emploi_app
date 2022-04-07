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
  final DateTime fakeNow = DateTime(2022, 2, 3, 4, 5, 30);

  test('create when rendezvous state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousLoadingState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is not initialized should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousNotInitializedState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is a failure should display failure', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousFailureState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  group('create when rendezvous state is success…', () {
    group('with rendezvous…', () {
      group('should display list', () {
        final rendezvous = [
          mockRendezvous(id: 'passés 1', date: DateTime(2022, 1, 4, 4, 5, 30)),
          mockRendezvous(id: 'passés 2', date: DateTime(2021, 12, 4, 4, 5, 30)),
          mockRendezvous(id: 'cette semaine 1', date: DateTime(2022, 2, 4, 4, 5, 30)),
          mockRendezvous(id: 'cette semaine 2', date: DateTime(2022, 2, 5, 4, 5, 30)),
          mockRendezvous(id: 'semaine prochaine 1', date: DateTime(2022, 2, 12, 4, 5, 30)),
          mockRendezvous(id: 'semaine prochaine 2', date: DateTime(2022, 2, 13, 4, 5, 30)),
        ];

        test('and sort them by last recent for this week', () {
          // Given
          final store = _loggedInMiloStore(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.rendezvousIds, [
            RendezVousItem(false, "Vendredi 04 février"),
            RendezVousItem(true, "cette semaine 1"),
            RendezVousItem(false, "Samedi 05 février"),
            RendezVousItem(true, "cette semaine 2"),
          ]);
        });

        test('and sort them by most recent for past', () {
          // Given
          final store = _loggedInMiloStore(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, -1);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, false);
          expect(viewModel.rendezvousIds, [
            RendezVousItem(false, "janvier 2022"),
            RendezVousItem(true, "passés 1"),
            RendezVousItem(false, "décembre 2021"),
            RendezVousItem(true, "passés 2"),
          ]);
        });

        test('and sort them by last recent for next week', () {
          // Given
          final store = _loggedInMiloStore(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 1);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, false);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.rendezvousIds, [
            RendezVousItem(false, "Samedi 12 février"),
            RendezVousItem(true, "semaine prochaine 1"),
            RendezVousItem(false, "Dimanche 13 février"),
            RendezVousItem(true, "semaine prochaine 2"),
          ]);
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
        final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

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
        final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

        // Then
        expect(viewModel.deeplinkRendezvousId, isNull);
      });
    });

    test('without rendezvous should display an empty content', () {
      // Given
      final store = _store([]);

      // When
      final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
      expect(viewModel.rendezvousIds.length, 0);
    });
  });

  test('onRetry should trigger RequestRendezvousAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<RendezvousRequestAction>());
  });

  test('onDeeplinkUsed should trigger ResetDeeplinkAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

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

Store<AppState> _loggedInMiloStore(List<Rendezvous> rendezvous) {
  return TestStoreFactory().initializeReduxStore(
    initialState: loggedInMiloState().copyWith(
      rendezvousState: RendezvousSuccessState(rendezvous),
    ),
  );
}
