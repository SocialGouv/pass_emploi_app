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
  final lundi22 = DateTime(2022, 8, 22);
  final actionLundi = userActionStub(
    id: "action 22/08 11h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-22T11:00:00.000Z"),
  );
  final actionJeudi = userActionStub(
    id: "action 25/08 10h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-25T10:00:00.000Z"),
  );

  final actionSamediProchain = userActionStub(
    id: "action 03/09 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-09-03T08:00:00.000Z"),
  );

  final demarcheSamediProchain = demarcheStub(
    id: "action 03/09 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-09-03T08:00:00.000Z"),
  );

  final rendezvousLundi = rendezvousStub(
    id: "rendezvous 22/08 15h",
    date: DateTime(2022, 8, 22, 15),
  );
  final rendezvousLundiProchain = rendezvousStub(
    id: "rendezvous 30/08 15h",
    date: DateTime(2022, 8, 30, 15),
  );
  final rendezvousMardiProchain = rendezvousStub(
    id: "rendezvous 31/08 11h",
    date: DateTime(2022, 8, 31, 11),
  );

  test('when this week is empty but not next week should arrange agenda with sorted events', () {
    // Given
    final demarches = [demarcheSamediProchain];
    final rendezvous = [rendezvousMardiProchain, rendezvousLundiProchain];
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .agenda(demarches: demarches, rendezvous: rendezvous, dateDeDebut: lundi22)
        .store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    expect(
      viewModel.events,
      [
        WeekSeparatorAgendaItem("Semaine en cours"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
        WeekSeparatorAgendaItem("Semaine prochaine"),
        RendezvousAgendaItem(rendezvousLundiProchain.id, collapsed: true),
        RendezvousAgendaItem(rendezvousMardiProchain.id, collapsed: true),
        DemarcheAgendaItem(demarcheSamediProchain.id, collapsed: true),
      ],
    );
  });
  test('when this week has events but not next week should arrange agenda with sorted events', () {
    // Given
    final actions = [actionJeudi, actionLundi];
    final rendezvous = [rendezvousLundi];
    final store = givenState() //
        .loggedInMiloUser()
        .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: lundi22)
        .store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    expect(
      viewModel.events,
      [
        DaySeparatorAgendaItem("Lundi 22 août"),
        UserActionAgendaItem(actionLundi.id),
        RendezvousAgendaItem(rendezvousLundi.id),
        DaySeparatorAgendaItem("Mardi 23 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
        DaySeparatorAgendaItem("Mercredi 24 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
        DaySeparatorAgendaItem("Jeudi 25 août"),
        UserActionAgendaItem(actionJeudi.id),
        DaySeparatorAgendaItem("Vendredi 26 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
        DaySeparatorAgendaItem("Samedi 27 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
        DaySeparatorAgendaItem("Dimanche 28 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
        WeekSeparatorAgendaItem("Semaine prochaine"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
      ],
    );
  });

  group('for Milo users', () {
    test('should display events call to action when there is nothing this week but something next week', () {
      // Given
      final actions = [actionSamediProchain];
      final rendezvous = [rendezvousLundiProchain];
      final store = givenState() //
          .loggedInMiloUser()
          .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: lundi22)
          .store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(
        viewModel.events,
        [
          CallToActionEventMiloAgendaItem(),
          WeekSeparatorAgendaItem("Semaine prochaine"),
          RendezvousAgendaItem(rendezvousLundiProchain.id, collapsed: true),
          UserActionAgendaItem(actionSamediProchain.id, collapsed: true),
        ],
      );
    });
    test('when empty should always display events call to action', () {
      // Given
      final store = givenState() //
          .loggedInMiloUser()
          .agenda(dateDeDebut: lundi22)
          .store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.events, [CallToActionEventMiloAgendaItem()]);
    });

    test('when empty with delayed actions should always display events call to action and delayed actions banner', () {
      // Given
      final store = givenState() //
          .loggedInMiloUser()
          .agenda(dateDeDebut: lundi22, delayedActions: 3)
          .store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.events, [
        DelayedActionsBannerAgendaItem("3 actions"),
        CallToActionEventMiloAgendaItem(),
      ]);
    });
  });
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

  group('isReloading', () {
    test('should be true on reloading state', () {
      // Given
      final store = givenState().loggedInMiloUser().copyWith(agendaState: AgendaReloadingState()).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.isReloading, isTrue);
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

    test('should be loading on reloading state', () {
      // Given
      final store = givenState().loggedInMiloUser().copyWith(agendaState: AgendaReloadingState()).store();

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
    test('when brand is BRSA should not display create button', () {
      // Given
      final store = givenBrsaState().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.createButton, null);
    });

    test('when brand is CEJ and user is from Mission Locale should set create button for user action', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.createButton, CreateButton.userAction);
    });

    test('when brand is CEJ and user is from Pole Emploi should set create button for user action', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda().store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.createButton, CreateButton.demarche);
    });
  });

  group('not up to date', () {
    test('when user is from Pole Emploi and API PE is KO, should have not-up-to-date item at first position', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda(
        actions: [actionJeudi],
        delayedActions: 7,
        dateDerniereMiseAjour: DateTime(2023),
      ).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.first, NotUpToDateAgendaItem());
    });

    test('when user is from Pole Emploi and API PE is OK, should not have not-up-to-date item', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda(
        actions: [actionJeudi],
        delayedActions: 7,
        dateDerniereMiseAjour: null,
      ).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.first, isNot(isA<NotUpToDateAgendaItem>()));
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

  test('should reset create action', () {
    // Given
    final store = StoreSpy();
    final viewModel = AgendaPageViewModel.create(store);

    // When
    viewModel.resetCreateAction();

    // Then
    expect(store.dispatchedAction, isA<UserActionCreateResetAction>());
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
    expectTypeThen<AgendaRequestReloadAction>(store.dispatchedAction, (action) {
      expect(action.maintenant, DateTime(2042));
    });
  });
}
