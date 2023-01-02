import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
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
  final lundi22 = DateTime(2022, 8, 22);
  final actionLundiMatin = userActionStub(
    id: "action 22/08 11h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-22T11:00:00.000Z"),
  );
  final actionMardiMatin = userActionStub(
    id: "action 23/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-23T08:00:00.000Z"),
  );
  final actionVendredi = userActionStub(
    id: "action 26/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-26T08:00:00.000Z"),
  );
  final actionSamedi = userActionStub(
    id: "action 27/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-27T08:00:00.000Z"),
  );

  final demarcheLundiMatin = demarcheStub(
    id: "demarche 22/08 11h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-22T11:00:00.000Z"),
  );
  final demarcheVendredi = demarcheStub(
    id: "demarche 26/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-26T08:00:00.000Z"),
  );
  final demarcheSamediProchain = demarcheStub(
    id: "demarche 27/08 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-27T08:00:00.000Z"),
  );

  final rendezvousLundiMatin = rendezvousStub(
    id: "rendezvous 22/08 15h",
    date: DateTime(2022, 8, 22, 15),
  );
  final rendezvousLundiProchain = rendezvousStub(
    id: "rendezvous 30/08 15h",
    date: DateTime(2022, 8, 30, 15),
  );

  group('isPoleEmploi', () {
    test('true when logged in with PE account', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.isPoleEmploi, true);
    });

    test('false when logged in with MILO account', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.isPoleEmploi, false);
    });
  });

  group('display state', () {
    test('should be loading on not initialize state', () {
      // Given
      final store = givenState().loggedInMiloUser().copyWith(agendaState: AgendaNotInitializedState()).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should be loading on loading state', () {
      // Given
      final store = givenState().loggedInMiloUser().copyWith(agendaState: AgendaLoadingState()).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should be failure on failure state', () {
      // Given
      final store = givenState().loggedInMiloUser().copyWith(agendaState: AgendaFailureState()).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('when user is from Mission Locale should be empty on success state without content', () {
      // Given
      final store = givenState().loggedInMiloUser().emptyAgenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
      expect(viewModel.emptyMessage, "Vous n'avez pas encore d'actions ni de rendez-vous prévus cette semaine.");
    });

    test('when user is from Pole Emploi should be empty on success state without content', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().emptyAgenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
      expect(viewModel.emptyMessage, "Vous n'avez pas encore de démarches ni de rendez-vous prévus cette semaine.");
    });

    test('should be content on success state with content for Mission Locale', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda(actions: [userActionStub()]).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('should be content on success state with content for Pole Emploi', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda(demarches: [demarcheStub()]).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });
  });

  group('create button', () {
    test('when user is from Mission Locale should set create button for user action', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.createButton, CreateButton.userAction);
    });

    test('when user is from Pole Emploi should set create button for user action', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.createButton, CreateButton.demarche);
    });
  });

  group('delayed items', () {
    test(
        'when user is from Mission Locale should have delayed item at first position when there are some delayed actions',
        () {
      // Given
      final store = givenState().loggedInMiloUser().agenda(delayedActions: 7).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.first, DelayedActionsBannerAgendaItem("7 actions"));
    });

    test('when user is from Pole Emploi should have delayed item at first position when there are some delayed actions',
        () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda(delayedActions: 7).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.first, DelayedActionsBannerAgendaItem("7 démarches"));
    });

    test('should not have delayed item if there isn\'t delayed any actions', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda(delayedActions: 0).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.firstWhereOrNull((item) => item is DelayedActionsBannerAgendaItem), null);
    });
  });

  group('events for Mission Locale (including user actions & rendezvous)', () {
    test('have both actions and rendezvous', () {
      // Given
      final actions = [userActionStub(), userActionStub()];
      final rendezvous = [rendezvousStub(), rendezvousStub(), rendezvousStub()];
      final store = givenState().loggedInMiloUser().agenda(actions: actions, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      final actualActionCount = _allEvents(viewModel.events).whereType<UserActionEventAgenda>().length;
      final actualRendezvousCount = _allEvents(viewModel.events).whereType<RendezvousEventAgenda>().length;
      expect(actualActionCount, 2);
      expect(actualRendezvousCount, 3);
    });

    test('are sorted by date', () {
      // Given
      final actions = [actionLundiMatin, actionMardiMatin, actionSamedi];
      final rendezvous = [rendezvousLundiMatin];
      final store = givenState().loggedInMiloUser().agenda(actions: actions, rendezvous: rendezvous).store();

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
      test('with current week empty if there is no event', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .agenda(actions: [], rendezvous: [], dateDeDebut: samedi20).store();

        // When
        final viewModel = AgendaPageViewModel.create(store);

        // Then
        expect(viewModel.events[0], CurrentWeekAgendaItem([]));
      });

      test('with current week starting at date debut as first day', () {
        // Given
        final actions = [actionLundiMatin, actionMardiMatin, actionVendredi, actionSamedi];
        final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
        final store = givenState() //
            .loggedInMiloUser()
            .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: lundi22)
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
            DaySectionAgenda("Samedi 27 août", [
              UserActionEventAgenda(actionSamedi.id, actionSamedi.dateEcheance),
            ]),
            DaySectionAgenda("Dimanche 28 août", []),
          ]),
        );
      });

      test('with next week', () {
        // Given
        final actions = [actionLundiMatin, actionMardiMatin, actionVendredi, actionSamedi];
        final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
        final store = givenState() //
            .loggedInMiloUser()
            .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: samedi20)
            .store();

        // When
        final viewModel = AgendaPageViewModel.create(store);

        // Then
        expect(
          viewModel.events[1],
          NextWeekAgendaItem([
            UserActionEventAgenda(actionSamedi.id, actionSamedi.dateEcheance),
            RendezvousEventAgenda(rendezvousLundiProchain.id, rendezvousLundiProchain.date),
          ]),
        );
      });
    });

    test('when there are no event for a day should return proper label', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.noEventLabel, 'Pas d’action ni de rendez-vous');
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
  });

  group('events for Pole Emploi (including demarches & rendezvous)', () {
    test('have both demarches and rendezvous', () {
      // Given
      final demarches = [demarcheStub()];
      final rendezvous = [rendezvousStub(), rendezvousStub(), rendezvousStub()];
      final store = givenState().loggedInPoleEmploiUser().agenda(demarches: demarches, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      final actualDemarcheCount = _allEvents(viewModel.events).whereType<DemarcheEventAgenda>().length;
      final actualRendezvousCount = _allEvents(viewModel.events).whereType<RendezvousEventAgenda>().length;
      expect(actualDemarcheCount, 1);
      expect(actualRendezvousCount, 3);
    });

    test('are sorted by date', () {
      // Given
      final demarches = [demarcheLundiMatin, demarcheVendredi, demarcheSamediProchain];
      final rendezvous = [rendezvousLundiMatin];
      final store = givenState().loggedInPoleEmploiUser().agenda(demarches: demarches, rendezvous: rendezvous).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      _expectEvents(items: viewModel.events, ids: [
        "demarche 22/08 11h",
        "rendezvous 22/08 15h",
        "demarche 26/08 08h",
        "demarche 27/08 08h",
      ]);
    });

    group('are grouped by week', () {
      test('with current week empty if there is no event', () {
        // Given
        final store = givenState() //
            .loggedInMiloUser()
            .agenda(demarches: [], rendezvous: [], dateDeDebut: samedi20).store();

        // When
        final viewModel = AgendaPageViewModel.create(store);

        // Then
        expect(viewModel.events[0], CurrentWeekAgendaItem([]));
      });

      test('with current week starting at date debut as first day', () {
        // Given
        final demarches = [demarcheLundiMatin, demarcheVendredi, demarcheSamediProchain];
        final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
        final store = givenState() //
            .loggedInPoleEmploiUser()
            .agenda(demarches: demarches, rendezvous: rendezvous, dateDeDebut: samedi20)
            .store();

        // When
        final viewModel = AgendaPageViewModel.create(store);

        // Then
        expect(
          viewModel.events[0],
          CurrentWeekAgendaItem([
            DaySectionAgenda("Samedi 20 août", []),
            DaySectionAgenda("Dimanche 21 août", []),
            DaySectionAgenda("Lundi 22 août", [
              DemarcheEventAgenda(demarcheLundiMatin.id, demarcheLundiMatin.endDate!),
              RendezvousEventAgenda(rendezvousLundiMatin.id, rendezvousLundiMatin.date),
            ]),
            DaySectionAgenda("Mardi 23 août", []),
            DaySectionAgenda("Mercredi 24 août", []),
            DaySectionAgenda("Jeudi 25 août", []),
            DaySectionAgenda("Vendredi 26 août", [
              DemarcheEventAgenda(demarcheVendredi.id, demarcheVendredi.endDate!),
            ]),
          ]),
        );
      });

      test('with next week', () {
        // Given
        final demarches = [demarcheLundiMatin, demarcheVendredi, demarcheSamediProchain];
        final rendezvous = [rendezvousLundiMatin, rendezvousLundiProchain];
        final store = givenState() //
            .loggedInPoleEmploiUser()
            .agenda(demarches: demarches, rendezvous: rendezvous, dateDeDebut: samedi20)
            .store();

        // When
        final viewModel = AgendaPageViewModel.create(store);

        // Then
        expect(
          viewModel.events[1],
          NextWeekAgendaItem([
            DemarcheEventAgenda(demarcheSamediProchain.id, demarcheSamediProchain.endDate!),
            RendezvousEventAgenda(rendezvousLundiProchain.id, rendezvousLundiProchain.date),
          ]),
        );
      });
    });

    test('when there are no event for a day should return proper label', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.noEventLabel, 'Pas de démarche ni de rendez-vous');
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
  });

  test('should go to event list', () {
    // Given
    final store = StoreSpy();
    final viewModel = AgendaPageViewModel.create(store);

    // When
    viewModel.goToEventList();

    // Then
    expect(store.dispatchedAction, LocalDeeplinkAction({"type": "EVENT_LIST"}));
  });

  test('should reload agenda', () {
    // Given
    final date = DateTime(2042);
    final store = StoreSpy();
    final viewModel = AgendaPageViewModel.create(store);

    // When
    viewModel.reload(date);

    // Then
    expectTypeThen<AgendaRequestAction>(store.dispatchedAction, (action) {
      expect(action.maintenant, DateTime(2042));
    });
  });
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
