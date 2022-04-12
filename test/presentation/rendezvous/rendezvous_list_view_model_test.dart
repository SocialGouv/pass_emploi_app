import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
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
          mockRendezvous(id: 'cette semaine 3', date: DateTime(2022, 2, 4, 2, 5, 30)),
          mockRendezvous(id: 'cette semaine 2', date: DateTime(2022, 2, 5, 4, 5, 30)),
          mockRendezvous(id: 'semaine+1 A', date: DateTime(2022, 2, 12, 4, 5, 30)),
          mockRendezvous(id: 'semaine+1 B', date: DateTime(2022, 2, 13, 4, 5, 30)),
          mockRendezvous(id: 'semaine+2 A', date: DateTime(2022, 2, 17, 4, 5, 30)),
          mockRendezvous(id: 'semaine+2 B', date: DateTime(2022, 2, 18, 4, 5, 30)),
          mockRendezvous(id: 'semaine+3 A', date: DateTime(2022, 2, 24, 4, 5, 30)),
          mockRendezvous(id: 'semaine+3 B', date: DateTime(2022, 2, 25, 4, 5, 30)),
          mockRendezvous(id: 'semaine+4 A', date: DateTime(2022, 3, 3, 4, 5, 30)),
          mockRendezvous(id: 'semaine+4 B', date: DateTime(2022, 3, 4, 4, 5, 30)),
          mockRendezvous(id: 'mois futur avril A', date: DateTime(2022, 4, 28, 4, 5, 30)),
          mockRendezvous(id: 'mois futur avril B', date: DateTime(2022, 4, 29, 4, 5, 30)),
          mockRendezvous(id: 'mois futur mai A', date: DateTime(2022, 5, 1, 4, 5, 30)),
        ];

        test('todo pas de bouton dans le passé si pas de RDV', () {
          expect(true, false);
        });

        test('todo semaine courante du lundi au vendredi', () {
          expect(true, false);
        });

        test('todo semaine courante, ne voit pas les rdv passés de la semaine (je suis mercredi, je ne vois pas lundi)',
            () {
          expect(true, false);
        });

        test('todo semaines futurs aussi du lundi au dimanche', () {
          expect(true, false);
        });

        test('todo mois futurs, ça commence aussi un lundi', () {
          expect(true, false);
        });

        test('todo état AUCUN rendez-vous du tout : titre et sous-titre dans semaine courante, chevrons bloqués', () {
          expect(true, false);
        });

        test('todo cette semaine en bleu', () {
          expect(true, false);
        });

        test('and sort them by most recent for past', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, -1);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, false);
          expect(viewModel.title, "Rendez-vous passés");
          expect(viewModel.dateLabel, "depuis le 04/12/2021");
          expect(viewModel.emptyLabel, "Vous n’avez pas encore de rendez-vous passés");
          expect(viewModel.analyticsLabel, "rdv/list-past");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Janvier 2022 (1)"),
            RendezVousCardItem("passés 1"),
            RendezVousDivider("Décembre 2021 (1)"),
            RendezVousCardItem("passés 2"),
          ]);
        });

        test('and sort them by last recent for this week', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Cette semaine");
          expect(viewModel.dateLabel, "03/02/2022 au 09/02/2022");
          expect(viewModel.emptyLabel, "Vous n’avez pas d’autres rendez-vous prévus cette semaine.");
          expect(viewModel.analyticsLabel, "rdv/list-week-0");
          expect(viewModel.rendezvousItems, [
            // todo add : aujourd'hui, demain
            RendezVousDivider("Vendredi 4 février"),
            RendezVousCardItem("cette semaine 3"),
            RendezVousCardItem("cette semaine 1"),
            RendezVousDivider("Samedi 5 février"),
            RendezVousCardItem("cette semaine 2"),
          ]);
        });

        test('and sort them by last recent for next week 1', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 1);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "10/02/2022 au 16/02/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 10/02/2022 au 16/02/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-1");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Samedi 12 février"),
            RendezVousCardItem("semaine+1 A"),
            RendezVousDivider("Dimanche 13 février"),
            RendezVousCardItem("semaine+1 B"),
          ]);
        });

        test('and sort them by last recent for next week 2', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 2);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "17/02/2022 au 23/02/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 17/02/2022 au 23/02/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-2");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Jeudi 17 février"),
            RendezVousCardItem("semaine+2 A"),
            RendezVousDivider("Vendredi 18 février"),
            RendezVousCardItem("semaine+2 B"),
          ]);
        });

        test('and sort them by last recent for next week 3', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 3);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "24/02/2022 au 02/03/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 24/02/2022 au 02/03/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-3");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Jeudi 24 février"),
            RendezVousCardItem("semaine+3 A"),
            RendezVousDivider("Vendredi 25 février"),
            RendezVousCardItem("semaine+3 B"),
          ]);
        });

        test('and sort them by last recent for next week 4', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 4);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "03/03/2022 au 09/03/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 03/03/2022 au 09/03/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-4");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Jeudi 3 mars"),
            RendezVousCardItem("semaine+4 A"),
            RendezVousDivider("Vendredi 4 mars"),
            RendezVousCardItem("semaine+4 B"),
          ]);
        });

        test('and sort them by last recent and grouped by month for next month', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, fakeNow, 5);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, false);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Rendez-vous futurs");
          expect(viewModel.dateLabel, "à partir du 10/03/2022");
          expect(viewModel.emptyLabel, "Vous n’avez pas encore de rendez-vous prévus");
          expect(viewModel.analyticsLabel, "rdv/list-future");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Avril 2022 (2)"),
            RendezVousCardItem("mois futur avril A"),
            RendezVousCardItem("mois futur avril B"),
            RendezVousDivider("Mai 2022 (1)"),
            RendezVousCardItem("mois futur mai A"),
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

      test("should not display date label when there isn't past rendezvous", () {
        // Given
        final DateTime now = DateTime(2022, 11, 30, 4, 5, 0);
        final rendezvous = [mockRendezvous(id: 'cette semaine 1', date: DateTime(2022, 11, 30, 4, 0, 0))];
        final store = _store(rendezvous);

        // When
        final viewModel = RendezvousListViewModel.create(store, now, -1);

        // Then
        expect(viewModel.dateLabel, "");
      });
    });

    test('without rendezvous should display an empty content', () {
      // Given
      final store = _store([]);

      // When
      final viewModel = RendezvousListViewModel.create(store, fakeNow, 0);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
      expect(viewModel.rendezvousItems.length, 0);
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
