import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_datetime.dart';

void main() {
  group('display state', () {
    test('should be loading on notinit state', () {
      // Given
      final store = givenState().loggedInUser().copyWith(agendaState: AgendaNotInitializedState()).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });
    test('should be loading on loading state', () {
      // Given
      final store = givenState().loggedInUser().copyWith(agendaState: AgendaLoadingState()).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should be failure on failure state', () {
      // Given
      final store = givenState().loggedInUser().copyWith(agendaState: AgendaFailureState()).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('should be empty on success state without content', () {
      // Given
      final store = givenState().loggedInUser().emptyAgenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });

    test('should be content on success state with content', () {
      // Given
      final store = givenState().loggedInUser().agenda(actions: [userActionStub()], rendezvous: []).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });
  });

  group('events', () {
    test('have both actions and rendezvous', () {
      // Given
      final actions = [userActionStub(), userActionStub()];
      final rendezvous = [rendezvousStub(), rendezvousStub(), rendezvousStub()];
      final store = givenState().loggedInUser().agenda(actions: actions, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      _expectCount(events: viewModel.events, actions: 2, rendezvous: 3);
    });
  });

  test('sont triés par date d\'échéance', () {
    // Given
    final actionLundiMatin = userActionStub(
        id: "action 22/08 11h", dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-22T11:00:00.000Z"));
    final rendezvousLundiMatin = rendezvousStub(id: "rendezvous 22/08 15h", date: DateTime(2022, 8, 22, 15));
    final actionMardiMatin = userActionStub(
        id: "action 23/08 08h", dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-23T08:00:00.000Z"));
    final actions = [actionLundiMatin, actionMardiMatin];
    final rendezvous = [rendezvousLundiMatin];
    final store = givenState().loggedInUser().agenda(actions: actions, rendezvous: rendezvous).store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    _expectEventsAreSorted(events: viewModel.events, ids: [
      "action 22/08 11h",
      "rendezvous 22/08 15h",
      "action 23/08 08h",
    ]);
  });
}

void _expectCount({required List<dynamic> events, required int actions, required int rendezvous}) {
  final actualActionCount = events.where((e) => e is UserActionViewModel).length;
  final actualRendezvousCount = events.where((e) => e is RendezvousAgendaViewModel).length;
  expect(actualActionCount, actions, reason: "Mauvais nombre d'actions");
  expect(actualRendezvousCount, rendezvous, reason: "Mauvais nombre de rendez-vous");
}

void _expectEventsAreSorted({required List<dynamic> events, required List<String> ids}) {
  final actualIds = events.map((e) {
    if (e is UserActionViewModel) return e.id;
    if (e is RendezvousAgendaViewModel) return e.id;
    return null;
  }).whereNotNull().toList();
  expect(actualIds, ids);
}
