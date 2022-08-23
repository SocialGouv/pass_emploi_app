import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_datetime.dart';

void main() {
  final actionLundiMatin = userActionStub(
    id: "action 22/08 11h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-22T11:00:00.000Z"),
  );
  final rendezvousLundiMatin = rendezvousStub(
    id: "rendezvous 22/08 15h",
    date: DateTime(2022, 8, 22, 15),
  );
  final actionMardiMatin = userActionStub(
    id: "action 23/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-23T08:00:00.000Z"),
  );

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
      _expectCount(sections: viewModel.events, actions: 2, rendezvous: 3);
    });

    test('are sorted by date', () {
      // Given
      final actions = [actionLundiMatin, actionMardiMatin];
      final rendezvous = [rendezvousLundiMatin];
      final store = givenState().loggedInUser().agenda(actions: actions, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      _expectEvents(sections: viewModel.events, ids: [
        "action 22/08 11h",
        "rendezvous 22/08 15h",
        "action 23/08 08h",
      ]);
    });

    test('are grouped by day', () {
      // Given
      final actions = [actionLundiMatin, actionMardiMatin];
      final rendezvous = [rendezvousLundiMatin];
      final store = givenState().loggedInUser().agenda(actions: actions, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.length, 2);
      _expectDaySection(viewModel.events[0], "Lundi 22 août", ["action 22/08 11h", "rendezvous 22/08 15h"]);
      _expectDaySection(viewModel.events[1], "Mardi 23 août", ["action 23/08 08h"]);
    });
  });
}

void _expectDaySection(DaySectionAgenda section, String title, List<String> eventIds) {
  expect(section.title, title);
  expect(section.events.map((e) => e.id), eventIds);
}

void _expectCount({required List<DaySectionAgenda> sections, required int actions, required int rendezvous}) {
  final actualActionCount = _allEvents(sections).whereType<UserActionEventAgenda>().length;
  final actualRendezvousCount = _allEvents(sections).whereType<RendezvousEventAgenda>().length;
  expect(actualActionCount, actions, reason: "Mauvais nombre d'actions");
  expect(actualRendezvousCount, rendezvous, reason: "Mauvais nombre de rendez-vous");
}

void _expectEvents({required List<DaySectionAgenda> sections, required List<String> ids}) {
  expect(_allEvents(sections).map((e) => e.id), ids);
}

List<EventAgenda> _allEvents(List<DaySectionAgenda> daySection) {
  return daySection.fold<List<EventAgenda>>([], (previousValue, element) => previousValue + element.events);
}
