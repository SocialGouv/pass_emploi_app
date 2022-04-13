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
  final DateTime thursday3thFebruary = DateTime(2022, 2, 3, 4, 5, 30);

  test('create when rendezvous state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousLoadingState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is not initialized should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousNotInitializedState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is a failure should display failure', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousFailureState()),
    );

    // When
    final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  // todo état AUCUN rendez-vous du tout : titre et sous-titre dans semaine courante, chevrons bloqués
  // todo cette semaine en bleu
  // todo tests pour les aujourd'hui / demain, requiert d'injecter la date.now

  group('create when rendezvous state is success…', () {
    group('with rendezvous…', () {
      test("should not navigate to past if there isn't past rendez-vous", () {
        // Given
        final rendezvous = [mockRendezvous(id: 'après-demain', date: DateTime(2022, 2, 5, 4, 5, 30))];
        final store = _store(rendezvous);
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
        // Then
        expect(viewModel.withPreviousButton, false);
      });

      group('past rendezvous of the current week', () {
        final rendezvous = [
          mockRendezvous(id: 'cette semaine lundi', date: DateTime(2022, 2, 1, 4, 5, 30)),
          mockRendezvous(id: 'cette semaine mardi', date: DateTime(2022, 2, 2, 4, 5, 30)),
          mockRendezvous(id: 'cette semaine dimanche', date: DateTime(2022, 2, 6, 4, 5, 30)),
        ];

        test("should not be displayed on current week page", () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
          // Then
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Dimanche 6 février"),
            RendezVousCardItem("cette semaine dimanche"),
          ]);
        });

        test("should be displayed on past page", () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, -1);
          // Then
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Février 2022 (2)"),
            RendezVousCardItem("cette semaine mardi"),
            RendezVousCardItem("cette semaine lundi"),
          ]);
        });
      });

      group('should display list', () {
        final rendezvous = [
          mockRendezvous(id: 'semaine passée 1', date: DateTime(2022, 1, 30, 4, 5, 30)),
          mockRendezvous(id: 'passés lointain 1', date: DateTime(2022, 1, 4, 4, 5, 30)),
          mockRendezvous(id: 'passés lointain 2', date: DateTime(2021, 12, 4, 4, 5, 30)),
          // mockRendezvous(id: 'cette semaine aujourdhui', date: DateTime(2022, 2, 3, 4, 5, 30)),
          // mockRendezvous(id: 'cette semaine demain 1', date: DateTime(2022, 2, 4, 1, 0, 0)),
          // mockRendezvous(id: 'cette semaine demain 2', date: DateTime(2022, 2, 4, 2, 5, 30)),
          mockRendezvous(id: 'cette semaine après-demain 1', date: DateTime(2022, 2, 5, 4, 5, 30)),
          mockRendezvous(id: 'cette semaine dimanche', date: DateTime(2022, 2, 6, 4, 5, 30)),
          mockRendezvous(id: 'semaine+1 lundi', date: DateTime(2022, 2, 7, 4, 5, 30)),
          mockRendezvous(id: 'semaine+1 jeudi', date: DateTime(2022, 2, 10, 4, 5, 30)),
          mockRendezvous(id: 'semaine+1 dimanche', date: DateTime(2022, 2, 13, 4, 5, 30)),
          mockRendezvous(id: 'semaine+2 lundi', date: DateTime(2022, 2, 14, 4, 5, 30)),
          mockRendezvous(id: 'semaine+2 jeudi', date: DateTime(2022, 2, 17, 4, 5, 30)),
          mockRendezvous(id: 'semaine+2 dimanche', date: DateTime(2022, 2, 20, 4, 5, 30)),
          mockRendezvous(id: 'semaine+3 lundi', date: DateTime(2022, 2, 21, 4, 5, 30)),
          mockRendezvous(id: 'semaine+3 jeudi', date: DateTime(2022, 2, 24, 4, 5, 30)),
          mockRendezvous(id: 'semaine+3 dimanche', date: DateTime(2022, 2, 27, 4, 5, 30)),
          mockRendezvous(id: 'semaine+4 lundi', date: DateTime(2022, 2, 28, 4, 5, 30)),
          mockRendezvous(id: 'semaine+4 jeudi', date: DateTime(2022, 3, 3, 4, 5, 30)),
          mockRendezvous(id: 'semaine+4 dimanche', date: DateTime(2022, 3, 6, 4, 5, 30)),
          mockRendezvous(id: 'mois futur lundi 7 mars', date: DateTime(2022, 3, 7, 4, 5, 30)),
          mockRendezvous(id: 'mois futur avril A', date: DateTime(2022, 4, 28, 4, 5, 30)),
          mockRendezvous(id: 'mois futur avril B', date: DateTime(2022, 4, 29, 4, 5, 30)),
        ];

        test('and sort them by most recent for past', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, -1);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, false);
          expect(viewModel.title, "Rendez-vous passés");
          expect(viewModel.dateLabel, "depuis le 04/12/2021");
          expect(viewModel.emptyLabel, "Vous n’avez pas encore de rendez-vous passés");
          expect(viewModel.analyticsLabel, "rdv/list-past");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Janvier 2022 (2)"),
            RendezVousCardItem("semaine passée 1"),
            RendezVousCardItem("passés lointain 1"),
            RendezVousDivider("Décembre 2021 (1)"),
            RendezVousCardItem("passés lointain 2"),
          ]);
        });

        test('and sort them by last recent for this week', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Cette semaine");
          expect(viewModel.dateLabel, "31/01/2022 au 06/02/2022");
          expect(viewModel.emptyLabel, "Vous n’avez pas d’autres rendez-vous prévus cette semaine.");
          expect(viewModel.analyticsLabel, "rdv/list-week-0");
          expect(viewModel.rendezvousItems, [
            // RendezVousDivider("Aujourd'hui"),
            // RendezVousCardItem("cette semaine aujourdhui"),
            // RendezVousDivider("Demain"),
            // RendezVousCardItem("cette semaine demain 1"),
            // RendezVousCardItem("cette semaine demain 2"),
            RendezVousDivider("Samedi 5 février"),
            RendezVousCardItem("cette semaine après-demain 1"),
            RendezVousDivider("Dimanche 6 février"),
            RendezVousCardItem("cette semaine dimanche"),
          ]);
        });

        test('and sort them by last recent for next week 1', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 1);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "07/02/2022 au 13/02/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 07/02/2022 au 13/02/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-1");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Lundi 7 février"),
            RendezVousCardItem("semaine+1 lundi"),
            RendezVousDivider("Jeudi 10 février"),
            RendezVousCardItem("semaine+1 jeudi"),
            RendezVousDivider("Dimanche 13 février"),
            RendezVousCardItem("semaine+1 dimanche"),
          ]);
        });

        test('and sort them by last recent for next week 2', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 2);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "14/02/2022 au 20/02/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 14/02/2022 au 20/02/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-2");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Lundi 14 février"),
            RendezVousCardItem("semaine+2 lundi"),
            RendezVousDivider("Jeudi 17 février"),
            RendezVousCardItem("semaine+2 jeudi"),
            RendezVousDivider("Dimanche 20 février"),
            RendezVousCardItem("semaine+2 dimanche"),
          ]);
        });

        test('and sort them by last recent for next week 3', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 3);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "21/02/2022 au 27/02/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 21/02/2022 au 27/02/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-3");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Lundi 21 février"),
            RendezVousCardItem("semaine+3 lundi"),
            RendezVousDivider("Jeudi 24 février"),
            RendezVousCardItem("semaine+3 jeudi"),
            RendezVousDivider("Dimanche 27 février"),
            RendezVousCardItem("semaine+3 dimanche"),
          ]);
        });

        test('and sort them by last recent for next week 4', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 4);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, true);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Semaine du");
          expect(viewModel.dateLabel, "28/02/2022 au 06/03/2022");
          expect(viewModel.emptyLabel,
              "Vous n’avez pas encore de rendez-vous prévus pour la semaine du 28/02/2022 au 06/03/2022");
          expect(viewModel.analyticsLabel, "rdv/list-week-4");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Lundi 28 février"),
            RendezVousCardItem("semaine+4 lundi"),
            RendezVousDivider("Jeudi 3 mars"),
            RendezVousCardItem("semaine+4 jeudi"),
            RendezVousDivider("Dimanche 6 mars"),
            RendezVousCardItem("semaine+4 dimanche"),
          ]);
        });

        test('and sort them by last recent and grouped by month for next month', () {
          // Given
          final store = _store(rendezvous);
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 5);
          // Then
          expect(viewModel.displayState, DisplayState.CONTENT);
          expect(viewModel.withNextButton, false);
          expect(viewModel.withPreviousButton, true);
          expect(viewModel.title, "Rendez-vous futurs");
          expect(viewModel.dateLabel, "à partir du 07/03/2022");
          expect(viewModel.emptyLabel, "Vous n’avez pas encore de rendez-vous prévus");
          expect(viewModel.analyticsLabel, "rdv/list-future");
          expect(viewModel.rendezvousItems, [
            RendezVousDivider("Mars 2022 (1)"),
            RendezVousCardItem("mois futur lundi 7 mars"),
            RendezVousDivider("Avril 2022 (2)"),
            RendezVousCardItem("mois futur avril A"),
            RendezVousCardItem("mois futur avril B"),
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
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

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
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

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
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
      expect(viewModel.rendezvousItems.length, 0);
    });
  });

  test('onRetry should trigger RequestRendezvousAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<RendezvousRequestAction>());
  });

  test('onDeeplinkUsed should trigger ResetDeeplinkAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

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
