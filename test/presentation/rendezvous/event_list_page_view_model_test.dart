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
    test('should have events when list succeed', () {
      // Given
      final rendezvous = [mockRendezvous(id: "id-1")];
      final store = givenState().loggedInUser().succeedEventList(rendezvous).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.eventIds, ["id-1"]);
    });
  });

  group('Display state', () {
    test('should display LOADING when not init', () {
      // Given
      final store = givenState().loggedInUser().copyWith(eventListState: EventListNotInitializedState()).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should display LOADING when loading', () {
      // Given
      final store = givenState().loggedInUser().copyWith(eventListState: EventListLoadingState()).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should display FAILURE when request failed', () {
      // Given
      final store = givenState().loggedInUser().copyWith(eventListState: EventListFailureState()).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('should display EMPTY when request succeed but has no rendezvous', () {
      // Given
      final store = givenState().loggedInUser().succeedEventList([]).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });

    test('should display CONTENT when request succeed with some rendezvous', () {
      // Given
      final store = givenState().loggedInUser().succeedEventList([mockRendezvous()]).store();

      // When
      final viewModel = EventListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
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
