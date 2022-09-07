import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';
import '../../utils/test_datetime.dart';

void main() {
  final samedi20 = DateTime(2022, 8, 20);
  final actionSamediMatin = userActionStub(
    id: "action 20/08 11h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-20T11:00:00.000Z"),
  );
  final actionDimancheMatin = userActionStub(
    id: "action 21/08 11h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-21T11:00:00.000Z"),
  );
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
  final actionVendredi = userActionStub(
    id: "action 26/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-26T08:00:00.000Z"),
  );
  final actionSamediProchain = userActionStub(
    id: "action 27/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-27T08:00:00.000Z"),
  );
  final rendezvousLundiProchain = rendezvousStub(
    id: "rendezvous 30/08 15h",
    date: DateTime(2022, 8, 30, 15),
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
    test('should have delayed item at first position when there are some delayed actions', () {
      // Given
      final store = givenState().loggedInUser().agenda(actions: [], rendezvous: [], delayedActions: 7).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.first, DelayedActionsBanner(7));
    });

    test('should not have delayed item if there isn\'t delayed any actions', () {
      // Given
      final store = givenState().loggedInUser().agenda(actions: [], rendezvous: [], delayedActions: 0).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.firstWhereOrNull((item) => item is DelayedActionsBanner), null);
    });

    test('have both actions and rendezvous', () {
      // Given
      final actions = [userActionStub(), userActionStub()];
      final rendezvous = [rendezvousStub(), rendezvousStub(), rendezvousStub()];
      final store = givenState().loggedInUser().agenda(actions: actions, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      _expectCount(items: viewModel.events, actions: 2, rendezvous: 3);
    });

    test('are sorted by date', () {
      // Given
      final actions = [actionLundiMatin, actionMardiMatin, actionSamediProchain];
      final rendezvous = [rendezvousLundiMatin];
      final store = givenState().loggedInUser().agenda(actions: actions, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      _expectEvents(items: viewModel.events, ids: [
        "action 22/08 11h",
        "rendezvous 22/08 15h",
        "action 23/08 08h",
        "action 27/08 08h",
      ]);
    });

    group('are grouped by week', () {
      group('with current week grouped by days', () {
        test('starting monday if no event on weekend', () {
          // Given
          final actions = [actionLundiMatin, actionMardiMatin, actionVendredi, actionSamediProchain];
          final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
          final store = givenState() //
              .loggedInUser()
              .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: samedi20)
              .store();

          // When
          final viewModel = AgendaPageViewModel.create(store);

          // Then
          expect(
            viewModel.events[0],
            CurrentWeekAgendaItem([
              DaySectionAgenda("Lundi 22 août", [
                UserActionEventAgenda(actionLundiMatin.id, actionLundiMatin.dateEcheance),
                RendezvousEventAgenda(rendezvousLundiMatin.id, rendezvousLundiMatin.date),
              ]),
              DaySectionAgenda("Mardi 23 août", [
                UserActionEventAgenda(actionMardiMatin.id, actionMardiMatin.dateEcheance),
              ]),
              DaySectionAgenda("Mercredi 24 août", []),
              DaySectionAgenda("Jeudi 25 août", []),
              DaySectionAgenda("Vendredi 26 août", [
                UserActionEventAgenda(actionVendredi.id, actionVendredi.dateEcheance),
              ]),
            ]),
          );
        });

        test('starting saturday if event on saturday', () {
          // Given
          final actions = [actionSamediMatin, actionLundiMatin, actionMardiMatin, actionVendredi, actionSamediProchain];
          final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
          final store = givenState() //
              .loggedInUser()
              .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: samedi20)
              .store();

          // When
          final viewModel = AgendaPageViewModel.create(store);

          // Then
          expect(
            viewModel.events[0],
            CurrentWeekAgendaItem([
              DaySectionAgenda("Samedi 20 août", [
                UserActionEventAgenda(actionSamediMatin.id, actionSamediMatin.dateEcheance),
              ]),
              DaySectionAgenda("Dimanche 21 août", []),
              DaySectionAgenda("Lundi 22 août", [
                UserActionEventAgenda(actionLundiMatin.id, actionLundiMatin.dateEcheance),
                RendezvousEventAgenda(rendezvousLundiMatin.id, rendezvousLundiMatin.date),
              ]),
              DaySectionAgenda("Mardi 23 août", [
                UserActionEventAgenda(actionMardiMatin.id, actionMardiMatin.dateEcheance),
              ]),
              DaySectionAgenda("Mercredi 24 août", []),
              DaySectionAgenda("Jeudi 25 août", []),
              DaySectionAgenda("Vendredi 26 août", [
                UserActionEventAgenda(actionVendredi.id, actionVendredi.dateEcheance),
              ]),
            ]),
          );
        });

        test('starting sunday if event on sunday and none saturday', () {
          // Given
          final actions = [actionDimancheMatin, actionLundiMatin, actionMardiMatin, actionVendredi, actionSamediProchain];
          final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
          final store = givenState() //
              .loggedInUser()
              .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: samedi20)
              .store();

          // When
          final viewModel = AgendaPageViewModel.create(store);

          // Then
          expect(
            viewModel.events[0],
            CurrentWeekAgendaItem([
              DaySectionAgenda("Dimanche 21 août", [
                UserActionEventAgenda(actionDimancheMatin.id, actionDimancheMatin.dateEcheance),
              ]),
              DaySectionAgenda("Lundi 22 août", [
                UserActionEventAgenda(actionLundiMatin.id, actionLundiMatin.dateEcheance),
                RendezvousEventAgenda(rendezvousLundiMatin.id, rendezvousLundiMatin.date),
              ]),
              DaySectionAgenda("Mardi 23 août", [
                UserActionEventAgenda(actionMardiMatin.id, actionMardiMatin.dateEcheance),
              ]),
              DaySectionAgenda("Mercredi 24 août", []),
              DaySectionAgenda("Jeudi 25 août", []),
              DaySectionAgenda("Vendredi 26 août", [
                UserActionEventAgenda(actionVendredi.id, actionVendredi.dateEcheance),
              ]),
            ]),
          );
        });
      });

      test('with next week', () {
        // Given
        final actions = [actionLundiMatin, actionMardiMatin, actionVendredi, actionSamediProchain];
        final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
        final store = givenState() //
            .loggedInUser()
            .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: samedi20)
            .store();

        // When
        final viewModel = AgendaPageViewModel.create(store);

        // Then
        expect(
          viewModel.events[1],
          NextWeekAgendaItem([
            UserActionEventAgenda(actionSamediProchain.id, actionSamediProchain.dateEcheance),
            RendezvousEventAgenda(rendezvousLundiProchain.id, rendezvousLundiProchain.date),
          ]),
        );
      });
    });

    test('should reset create action', () {
      // Given
      final store = StoreSpy();
      final viewModel = AgendaPageViewModel.create(store);

      // When
      viewModel.resetCreateAction();

      // Then
      expect(store.dispatchedAction, isA<UserActionCreateResetAction>());
    });

    test('should retry fetching agenda', () {
      // Given
      final date = DateTime(2042);
      final store = StoreSpy();
      final viewModel = AgendaPageViewModel.create(store);

      // When
      viewModel.retry(date);

      // Then
      expectTypeThen<AgendaRequestAction>(store.dispatchedAction, (action) {
        expect(action.maintenant, DateTime(2042));
      });
    });
  });
}

void _expectCount({required List<AgendaItem> items, required int actions, required int rendezvous}) {
  final actualActionCount = _allEvents(items).whereType<UserActionEventAgenda>().length;
  final actualRendezvousCount = _allEvents(items).whereType<RendezvousEventAgenda>().length;
  expect(actualActionCount, actions, reason: "Mauvais nombre d'actions");
  expect(actualRendezvousCount, rendezvous, reason: "Mauvais nombre de rendez-vous");
}

void _expectEvents({required List<AgendaItem> items, required List<String> ids}) {
  expect(_allEvents(items).map((e) => e.id), ids);
}

List<EventAgenda> _allEvents(List<AgendaItem> items) {
  return items.fold<List<EventAgenda>>([], (previousValue, item) {
    if (item is CurrentWeekAgendaItem) return previousValue + _allEventsFromDaySections(item.days);
    return previousValue;
  });
}

List<EventAgenda> _allEventsFromDaySections(List<DaySectionAgenda> days) {
  return days.fold<List<EventAgenda>>([], (previousValue, daySection) {
    return previousValue + daySection.events;
  });
}
