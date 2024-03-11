import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';
import '../../utils/test_datetime.dart';

void main() {
  final lundi22 = DateTime(2022, 8, 22);
  final demarcheLundi = demarcheStub(
    id: "demarche 22/08 11h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-22T11:00:00.000Z"),
  );

  final demarcheJeudi = demarcheStub(
    id: "demarche 25/08 10h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-08-25T10:00:00.000Z"),
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

  final sessionMiloLundi = mockSessionMilo(
    id: "session 22/08 17h",
    dateDeDebut: DateTime(2022, 8, 22, 17),
  );

  test('should display empty current week when there is nothing this week but something next week', () {
    // Given
    final demarches = [demarcheSamediProchain];
    final rendezvous = [rendezvousLundiProchain];
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
        EmptyMessageAgendaItem(
            "Pas de démarche ni de rendez-vous. Ajoutez une nouvelle démarche ou découvrez des événements en cliquant sur “Événements”, en bas de l’écran."),
        WeekSeparatorAgendaItem("Semaine prochaine"),
        RendezvousAgendaItem(rendezvousLundiProchain.id),
        DemarcheAgendaItem(demarcheSamediProchain.id),
      ],
    );
  });

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
        EmptyMessageAgendaItem(
            "Pas de démarche ni de rendez-vous. Ajoutez une nouvelle démarche ou découvrez des événements en cliquant sur “Événements”, en bas de l’écran."),
        WeekSeparatorAgendaItem("Semaine prochaine"),
        RendezvousAgendaItem(rendezvousLundiProchain.id),
        RendezvousAgendaItem(rendezvousMardiProchain.id),
        DemarcheAgendaItem(demarcheSamediProchain.id),
      ],
    );
  });

  test('when this week has events but not next week should arrange agenda with sorted events', () {
    // Given
    final demarches = [demarcheJeudi, demarcheLundi];
    final rendezvous = [rendezvousLundi];
    final sessions = [sessionMiloLundi];
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .agenda(
          demarches: demarches,
          rendezvous: rendezvous,
          sessionsMilo: sessions,
          dateDeDebut: lundi22,
        )
        .store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    expect(
      viewModel.events,
      [
        DaySeparatorAgendaItem("Lundi 22 août"),
        DemarcheAgendaItem(demarcheLundi.id),
        RendezvousAgendaItem(rendezvousLundi.id),
        SessionMiloAgendaItem(sessionMiloLundi.id),
        DaySeparatorAgendaItem("Mardi 23 août"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
        DaySeparatorAgendaItem("Mercredi 24 août"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
        DaySeparatorAgendaItem("Jeudi 25 août"),
        DemarcheAgendaItem(demarcheJeudi.id),
        DaySeparatorAgendaItem("Vendredi 26 août"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
        DaySeparatorAgendaItem("Samedi 27 août"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
        DaySeparatorAgendaItem("Dimanche 28 août"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
        WeekSeparatorAgendaItem("Semaine prochaine"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
      ],
    );
  });

  test('when empty should display empty item', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .agenda(dateDeDebut: lundi22)
        .store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.events, [EmptyAgendaItem()]);
  });

  test('when empty with delayed démarches should display empty item and delayed actions banner', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .agenda(dateDeDebut: lundi22, delayedActions: 3)
        .store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.events, [
      DelayedActionsBannerAgendaItem("3 démarches"),
      EmptyAgendaItem(),
    ]);
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

    test('should be content on success state with content for Pole Emploi', () {
      // Given
      final store = givenState().loggedInMiloUser().agenda(demarches: [demarcheStub()]).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });
  });

  group('not up to date', () {
    test('when user is from Pole Emploi and API PE is KO, should have not-up-to-date item at first position', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().agenda(
        demarches: [demarcheJeudi],
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
        demarches: [demarcheJeudi],
        delayedActions: 7,
        dateDerniereMiseAjour: null,
      ).store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.events.first, isNot(isA<NotUpToDateAgendaItem>()));
    });
  });

  test('should go to event list', () {
    // Given
    final store = StoreSpy();
    final viewModel = AgendaPageViewModel.create(store);

    // When
    viewModel.goToEventList();

    // Then
    expect(store.dispatchedAction, HandleDeepLinkAction(EventListDeepLink(), DeepLinkOrigin.inAppNavigation));
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

  group('onboarding', () {
    test('should display onboarding', () {
      // Given
      final store = givenState()
          .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showMonSuiviOnboarding: true)))
          .store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowOnboarding, isTrue);
    });

    test('should not display onboarding', () {
      // Given
      final store = givenState()
          .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showMonSuiviOnboarding: false)))
          .store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowOnboarding, isFalse);
    });
  });
}
