import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/events/event_list_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('Events', () {
    test('should have events when list succeed ordered by date', () {
      // Given
      final rendezvous = [mockRendezvous(id: "id-2", date: DateTime(2022))];
      final sessions = [
        mockSessionMilo(id: "id-1", dateDeDebut: DateTime(2021)),
        mockSessionMilo(id: "id-3", dateDeDebut: DateTime(2023)),
      ];
      final store = givenState()
          .loggedInUser()
          .succeedEventList(animationsCollectives: rendezvous, sessionsMilo: sessions)
          .store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.eventIds, [
        SessionMiloId("id-1"),
        AnimationCollectiveId("id-2"),
        SessionMiloId("id-3"),
      ]);
    });
  });

  group('Display state', () {
    test('should display LOADING when not init', () {
      // Given
      final store = givenState().loggedInUser().copyWith(eventListState: EventListNotInitializedState()).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test('should display LOADING when loading', () {
      // Given
      final store = givenState().loggedInUser().copyWith(eventListState: EventListLoadingState()).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test('should display FAILURE when request failed', () {
      // Given
      final store = givenState().loggedInUser().copyWith(eventListState: EventListFailureState()).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });

    test('should display EMPTY when request succeed but has no events', () {
      // Given
      final store = givenState().loggedInUser().succeedEventList(animationsCollectives: [], sessionsMilo: []).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.vide);
    });

    test('should display CONTENT when request succeed with some animations collectives', () {
      // Given
      final store = givenState().loggedInUser().succeedEventList(animationsCollectives: [mockRendezvous()]).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test('should display CONTENT when request succeed with some sessions milo', () {
      // Given
      final store = givenState().loggedInUser().succeedEventList(sessionsMilo: [mockSessionMiloAtelierCv()]).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test('should display CONTENT when request succeed with both sessions milo and animations collectives', () {
      // Given
      final store = givenState().loggedInUser().succeedEventList(
        animationsCollectives: [mockRendezvous()],
        sessionsMilo: [mockSessionMiloAtelierCv()],
      ).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });
  });

  test('should retry', () {
    // Given
    final store = StoreSpy();
    final viewModel = EventListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<EventListRequestAction>());
  });
}
