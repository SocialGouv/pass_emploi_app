import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
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
  final actionSamediProchain = userActionStub(
    id: "action 03/09 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-09-03T08:00:00.000Z"),
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
    id: "action 03/09 08h",
    dateEcheance: parseDateTimeUtcWithCurrentTimeZone("2022-09-03T08:00:00.000Z"),
  );

  final rendezvousLundiMatin = rendezvousStub(
    id: "rendezvous 22/08 15h",
    date: DateTime(2022, 8, 22, 15),
  );
  final rendezvousLundiProchain = rendezvousStub(
    id: "rendezvous 30/08 15h",
    date: DateTime(2022, 8, 30, 15),
  );

  test('when this week is empty but not next week', () {
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
      viewModel.events2,
      [
        WeekSeparatorAgendaItem("Semaine en cours"),
        EmptyMessageAgendaItem("Pas de démarche ni de rendez-vous"),
        WeekSeparatorAgendaItem("Semaine prochaine"),
        RendezvousAgendaItem(rendezvousLundiProchain.id, collapsed: true),
        DemarcheAgendaItem(demarcheSamediProchain.id, collapsed: true),
      ],
    );
  });
  test('when this week has one event but not next week', () {
    // Given
    final actions = [actionLundiMatin];
    final rendezvous = [rendezvousLundiMatin];
    final store = givenState() //
        .loggedInMiloUser()
        .agenda(actions: actions, rendezvous: rendezvous, dateDeDebut: lundi22)
        .store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    expect(
      viewModel.events2,
      [
        DaySeparatorAgendaItem("Lundi 22 août"),
        UserActionAgendaItem(actionLundiMatin.id),
        RendezvousAgendaItem(rendezvousLundiMatin.id),
        DaySeparatorAgendaItem("Mardi 23 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
        DaySeparatorAgendaItem("Mercredi 24 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
        DaySeparatorAgendaItem("Jeudi 25 août"),
        EmptyMessageAgendaItem("Pas d’action ni de rendez-vous"),
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
        viewModel.events2,
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
      expect(viewModel.events2, [CallToActionEventMiloAgendaItem()]);
    });

    test('when empty with delayed actions should always display events call to action and delayed action banner', () {
      // Given
      final store = givenState() //
          .loggedInMiloUser()
          .agenda(dateDeDebut: lundi22, delayedActions: 3)
          .store();

      // When
      final viewModel = AgendaPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.events2, [
        DelayedActionsBannerAgendaItem("3 actions"),
        CallToActionEventMiloAgendaItem(),
      ]);
    });
  });
}
