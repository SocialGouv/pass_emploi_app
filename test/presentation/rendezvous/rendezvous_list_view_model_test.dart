import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  final DateTime thursday3thFebruary = DateTime(2022, 2, 3, 4, 5, 30);

  group('when fetching rendez-vous futurs', () {
    test('when not initialized should display loading', () {
      // Given
      final store = givenState().loggedInUser().rendezvousNotInitialized().store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when loading should display loading', () {
      // Given
      final store = givenState().loggedInUser().loadingFutureRendezvous().store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should display failure', () {
      // Given
      final store = givenState().loggedInUser().failedFutureRendezvous().store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });

  group('when having rendez-vous futurs', () {
    test("should not navigate to past when logged in Pole Emploi", () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().rendezvous([]).store();
      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
      // Then
      expect(viewModel.withPreviousPageButton, false);
    });

    test("should navigate to past when logged in MiLo", () {
      // Given
      final store = givenState().loggedInMiloUser().rendezvous([]).store();
      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
      // Then
      expect(viewModel.withPreviousPageButton, true);
    });
  });

  group('when having rendez-vous futurs and fetching rendez-vous pass??s', () {
    test('when not initialized should display loading', () {
      // Given
      final store = givenState().loggedInUser().rendezvousNotInitialized().store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, -1);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when loading should display loading', () {
      // Given
      final store = givenState().loggedInUser().loadingPastRendezvous().store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, -1);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should display failure', () {
      // Given
      final store = givenState().loggedInUser().failedPastRendezvous().store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, -1);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });

  group('when having rendez-vous futurs and pass??s', () {
    group('should display pages', () {
      final rendezvous = [
        mockRendezvous(id: 'semaine pass??e 1', date: DateTime(2022, 1, 30, 4, 5, 30)),
        mockRendezvous(id: 'pass??s lointain 1', date: DateTime(2022, 1, 4, 4, 5, 30)),
        mockRendezvous(id: 'pass??s lointain 2', date: DateTime(2021, 12, 4, 4, 5, 30)),
        mockRendezvous(id: 'cette semaine apr??s-demain 1', date: DateTime(2022, 2, 5, 4, 5, 30)),
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
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, -1);
        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
        expect(viewModel.withNextPageButton, true);
        expect(viewModel.withPreviousPageButton, false);
        expect(viewModel.title, "Rendez-vous pass??s");
        expect(viewModel.dateLabel, "depuis le 04/12/2021");
        expect(viewModel.emptyLabel, "Vous n???avez pas encore de rendez-vous pass??s");
        expect(viewModel.emptySubtitleLabel, isNull);
        expect(viewModel.analyticsLabel, "rdv/list-past");
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Janvier 2022 (2)",
            displayedRendezvous: ["semaine pass??e 1", "pass??s lointain 1"],
          ),
          RendezvousSection(
            title: "D??cembre 2021 (1)",
            displayedRendezvous: ["pass??s lointain 2"],
          ),
        ]);
      });

      test('and sort them by last recent for this week', () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
        expect(viewModel.withNextPageButton, true);
        expect(viewModel.withPreviousPageButton, true);
        expect(viewModel.title, "Cette semaine");
        expect(viewModel.dateLabel, "31/01/2022 au 06/02/2022");
        expect(viewModel.emptyLabel, "Vous n'avez pas encore de rendez-vous pr??vus cette semaine");
        expect(viewModel.emptySubtitleLabel, isNull);
        expect(viewModel.analyticsLabel, "rdv/list-week-0");
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Samedi 5 f??vrier",
            displayedRendezvous: ["cette semaine apr??s-demain 1"],
          ),
          RendezvousSection(
            title: "Dimanche 6 f??vrier",
            displayedRendezvous: ["cette semaine dimanche"],
          ),
        ]);
      });

      test('and sort them by last recent for next week 1', () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 1);
        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
        expect(viewModel.withNextPageButton, true);
        expect(viewModel.withPreviousPageButton, true);
        expect(viewModel.title, "Semaine du");
        expect(viewModel.dateLabel, "07/02/2022 au 13/02/2022");
        expect(viewModel.emptyLabel,
            "Vous n???avez pas encore de rendez-vous pr??vus pour la semaine du 07/02/2022 au 13/02/2022");
        expect(viewModel.emptySubtitleLabel, isNull);
        expect(viewModel.analyticsLabel, "rdv/list-week-1");
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Lundi 7 f??vrier",
            displayedRendezvous: ["semaine+1 lundi"],
          ),
          RendezvousSection(
            title: "Jeudi 10 f??vrier",
            displayedRendezvous: ["semaine+1 jeudi"],
          ),
          RendezvousSection(
            title: "Dimanche 13 f??vrier",
            displayedRendezvous: ["semaine+1 dimanche"],
          ),
        ]);
      });

      test('and sort them by last recent for next week 2', () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 2);
        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
        expect(viewModel.withNextPageButton, true);
        expect(viewModel.withPreviousPageButton, true);
        expect(viewModel.title, "Semaine du");
        expect(viewModel.dateLabel, "14/02/2022 au 20/02/2022");
        expect(viewModel.emptyLabel,
            "Vous n???avez pas encore de rendez-vous pr??vus pour la semaine du 14/02/2022 au 20/02/2022");
        expect(viewModel.emptySubtitleLabel, isNull);
        expect(viewModel.analyticsLabel, "rdv/list-week-2");
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Lundi 14 f??vrier",
            displayedRendezvous: ["semaine+2 lundi"],
          ),
          RendezvousSection(
            title: "Jeudi 17 f??vrier",
            displayedRendezvous: ["semaine+2 jeudi"],
          ),
          RendezvousSection(
            title: "Dimanche 20 f??vrier",
            displayedRendezvous: ["semaine+2 dimanche"],
          ),
        ]);
      });

      test('and sort them by last recent for next week 3', () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 3);
        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
        expect(viewModel.withNextPageButton, true);
        expect(viewModel.withPreviousPageButton, true);
        expect(viewModel.title, "Semaine du");
        expect(viewModel.dateLabel, "21/02/2022 au 27/02/2022");
        expect(viewModel.emptyLabel,
            "Vous n???avez pas encore de rendez-vous pr??vus pour la semaine du 21/02/2022 au 27/02/2022");
        expect(viewModel.emptySubtitleLabel, isNull);
        expect(viewModel.analyticsLabel, "rdv/list-week-3");
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Lundi 21 f??vrier",
            displayedRendezvous: ["semaine+3 lundi"],
          ),
          RendezvousSection(
            title: "Jeudi 24 f??vrier",
            displayedRendezvous: ["semaine+3 jeudi"],
          ),
          RendezvousSection(
            title: "Dimanche 27 f??vrier",
            displayedRendezvous: ["semaine+3 dimanche"],
          ),
        ]);
      });

      test('and sort them by last recent for next week 4', () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 4);
        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
        expect(viewModel.withNextPageButton, true);
        expect(viewModel.withPreviousPageButton, true);
        expect(viewModel.title, "Semaine du");
        expect(viewModel.dateLabel, "28/02/2022 au 06/03/2022");
        expect(viewModel.emptyLabel,
            "Vous n???avez pas encore de rendez-vous pr??vus pour la semaine du 28/02/2022 au 06/03/2022");
        expect(viewModel.emptySubtitleLabel, isNull);
        expect(viewModel.analyticsLabel, "rdv/list-week-4");
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Lundi 28 f??vrier",
            displayedRendezvous: ["semaine+4 lundi"],
          ),
          RendezvousSection(
            title: "Jeudi 3 mars",
            displayedRendezvous: ["semaine+4 jeudi"],
          ),
          RendezvousSection(
            title: "Dimanche 6 mars",
            displayedRendezvous: ["semaine+4 dimanche"],
          ),
        ]);
      });

      test('and sort them by last recent and grouped by month for next month', () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 5);
        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
        expect(viewModel.withNextPageButton, false);
        expect(viewModel.withPreviousPageButton, true);
        expect(viewModel.title, "Rendez-vous futurs");
        expect(viewModel.dateLabel, "?? partir du 07/03/2022");
        expect(viewModel.emptyLabel, "Vous n???avez pas encore de rendez-vous pr??vus");
        expect(viewModel.emptySubtitleLabel, isNull);
        expect(viewModel.analyticsLabel, "rdv/list-future");
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Mars 2022 (1)",
            displayedRendezvous: ["mois futur lundi 7 mars"],
          ),
          RendezvousSection(
            title: "Avril 2022 (2)",
            displayedRendezvous: ["mois futur avril A", "mois futur avril B"],
          ),
        ]);
      });
    });

    group('expandable sections', () {
      final threeRendezvous = [
        mockRendezvous(id: 'lundi', date: DateTime(2022, 2, 1, 4, 5, 30)),
        mockRendezvous(id: 'mardi', date: DateTime(2022, 2, 2, 4, 5, 30)),
        mockRendezvous(id: 'dimanche', date: DateTime(2022, 2, 6, 4, 5, 30)),
      ];
      final fourRendezvous = [
        mockRendezvous(id: 'lundi', date: DateTime(2022, 2, 1, 4, 5, 30)),
        mockRendezvous(id: 'mardi', date: DateTime(2022, 2, 2, 4, 5, 30)),
        mockRendezvous(id: 'mercredi', date: DateTime(2022, 2, 3, 4, 5, 30)),
        mockRendezvous(id: 'dimanche', date: DateTime(2022, 2, 6, 4, 5, 30)),
      ];

      void assertSections({
        required int pageOffset,
        required List<Rendezvous> rendezvous,
        required bool shouldBeExpandable,
        required String message,
      }) {
        test(message, () {
          // Given
          final rendezvousOnPage = rendezvous.map((e) {
            return mockRendezvous(id: e.id, date: e.date.addWeeks(pageOffset));
          }).toList();
          final store = givenState().loggedInUser().rendezvous(rendezvousOnPage).store();
          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, pageOffset);
          // Then
          expect(
            viewModel.rendezvous.indexWhere((section) => section.expandableRendezvous.isNotEmpty) != -1,
            shouldBeExpandable,
          );
        });
      }

      assertSections(
          pageOffset: 0,
          rendezvous: fourRendezvous,
          shouldBeExpandable: false,
          message: "should not be on present page");
      assertSections(
          pageOffset: 1,
          rendezvous: fourRendezvous,
          shouldBeExpandable: false,
          message: "should not be on week+1 page");
      assertSections(
          pageOffset: 2,
          rendezvous: fourRendezvous,
          shouldBeExpandable: false,
          message: "should not be on week+2 page");
      assertSections(
          pageOffset: 3,
          rendezvous: fourRendezvous,
          shouldBeExpandable: false,
          message: "should not be on week+3 page");
      assertSections(
          pageOffset: 4,
          rendezvous: fourRendezvous,
          shouldBeExpandable: false,
          message: "should not be on week+4 page");
      assertSections(
          pageOffset: -1,
          rendezvous: threeRendezvous,
          shouldBeExpandable: false,
          message: "should not be on past page with less than 3 rdv");
      assertSections(
          pageOffset: 5,
          rendezvous: threeRendezvous,
          shouldBeExpandable: false,
          message: "should not be on future months page with less than 3 rdv");
      assertSections(
          pageOffset: -1,
          rendezvous: fourRendezvous,
          shouldBeExpandable: true,
          message: "should be on past page with more than 3 rdv");
      assertSections(
          pageOffset: 5,
          rendezvous: fourRendezvous,
          shouldBeExpandable: true,
          message: "should be on future months page with more than 3 rdv");
    });

    group('past rendezvous of the current week', () {
      final rendezvous = [
        mockRendezvous(id: 'cette semaine lundi', date: DateTime(2022, 2, 1, 4, 5, 30)),
        mockRendezvous(id: 'cette semaine mardi', date: DateTime(2022, 2, 2, 4, 5, 30)),
        mockRendezvous(id: 'cette semaine dimanche', date: DateTime(2022, 2, 6, 4, 5, 30)),
      ];

      test("should not be displayed on current week page", () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
        // Then
        expect(viewModel.withPreviousPageButton, true);
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "Dimanche 6 f??vrier",
            displayedRendezvous: ["cette semaine dimanche"],
          ),
        ]);
      });

      test("should be displayed on past page", () {
        // Given
        final store = givenState().loggedInUser().rendezvous(rendezvous).store();
        // When
        final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, -1);
        // Then
        expect(viewModel.rendezvous, [
          RendezvousSection(
            title: "F??vrier 2022 (2)",
            displayedRendezvous: ["cette semaine mardi", "cette semaine lundi"],
          ),
        ]);
      });
    });

    test("should have an empty rendezvous display", () {
      // Given
      final store = givenState().loggedInUser().rendezvous([]).store();
      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);
      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.withPreviousPageButton, true);
      expect(viewModel.withNextPageButton, true);
      expect(viewModel.emptyLabel, "Vous n'avez pas encore de rendez-vous pr??vus");
      expect(viewModel.emptySubtitleLabel,
          "Vous pouvez consulter ceux pass??s et ?? venir en utilisant les fl??ches en haut de page.");
    });

    group('should handle next rendezvous button???', () {
      void assertPageOffsetOfNextRendezvous({
        required List<Rendezvous> rendezvous,
        required int pageOffset,
        required int? expectedPageOffsetOfNextRendezvous,
      }) {
        test("${rendezvous.map((e) => e.id)} at page $pageOffset-> $expectedPageOffsetOfNextRendezvous", () {
          // Given
          final store = givenState().loggedInUser().rendezvous(rendezvous).store();

          // When
          final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, pageOffset);

          // Then
          expect(viewModel.nextRendezvousPageOffset, expectedPageOffsetOfNextRendezvous);
        });
      }

      test("Bug fix with today on monday morning, to week + 2 on monday afternoon", () {
        // Given
        final rendezVous = [mockRendezvous(id: 'semaine+2 lundi matin', date: DateTime(2022, 2, 14, 3, 5, 30))];
        final store = givenState().loggedInUser().rendezvous(rendezVous).store();
        final monday31JanuaryAfternoon = DateTime(2022, 1, 31, 16, 5, 30);
        // When
        final viewModel = RendezvousListViewModel.create(store, monday31JanuaryAfternoon, 0);
        // Then
        expect(viewModel.nextRendezvousPageOffset, 2);
      });

      assertPageOffsetOfNextRendezvous(
        rendezvous: [
          mockRendezvous(id: 'semaine pass??e 1', date: DateTime(2022, 1, 30, 4, 5, 30)),
          mockRendezvous(id: 'pass??s lointain 1', date: DateTime(2022, 1, 4, 4, 5, 30)),
        ],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: null,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [
          mockRendezvous(id: 'semaine pass??e 1', date: DateTime(2022, 1, 30, 4, 5, 30)),
          mockRendezvous(id: 'pass??s lointain 1', date: DateTime(2022, 1, 4, 4, 5, 30)),
        ],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: null,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [
          mockRendezvous(id: 'cette semaine apr??s-demain 1', date: DateTime(2022, 2, 5, 4, 5, 30)),
          mockRendezvous(id: 'semaine+1 lundi', date: DateTime(2022, 2, 7, 4, 5, 30)),
        ],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: null,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'semaine+2 lundi', date: DateTime(2022, 2, 14, 4, 5, 30))],
        pageOffset: 1,
        expectedPageOffsetOfNextRendezvous: null,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'semaine+1 lundi', date: DateTime(2022, 2, 7, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 1,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [
          mockRendezvous(id: 'cette semaine hier', date: DateTime(2022, 2, 2, 4, 5, 30)),
          mockRendezvous(id: 'semaine+1 lundi', date: DateTime(2022, 2, 7, 4, 5, 30)),
        ],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 1,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'semaine+2 lundi', date: DateTime(2022, 2, 14, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 2,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'semaine+2 mardi', date: DateTime(2022, 2, 15, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 2,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'semaine+3 lundi', date: DateTime(2022, 2, 21, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 3,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'semaine+4 jeudi', date: DateTime(2022, 3, 3, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 4,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'semaine+4 dimanche', date: DateTime(2022, 3, 6, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 4,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: 'mois futur lundi 7 mars', date: DateTime(2022, 3, 7, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 5,
      );

      assertPageOffsetOfNextRendezvous(
        rendezvous: [mockRendezvous(id: '2 mois futur mardi 12 avril', date: DateTime(2022, 4, 12, 4, 5, 30))],
        pageOffset: 0,
        expectedPageOffsetOfNextRendezvous: 5,
      );
    });

    test("should not display date label when there isn't past rendezvous", () {
      // Given
      final DateTime now = DateTime(2022, 11, 30, 4, 5, 0);
      final rendezvous = [mockRendezvous(id: 'cette semaine 1', date: DateTime(2022, 11, 30, 4, 0, 0))];
      final store = givenState().loggedInUser().rendezvous(rendezvous).store();

      // When
      final viewModel = RendezvousListViewModel.create(store, now, -1);

      // Then
      expect(viewModel.dateLabel, "");
    });

    test('should handle deeplink with valid ID', () {
      // Given
      final store = givenState().rendezvous([mockRendezvous(id: '1')]).deeplinkToRendezvous('1').store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

      // Then
      expect(viewModel.deeplinkRendezvousId, '1');
    });

    test('should handle deeplink with invalid ID', () {
      // Given
      final store = givenState().rendezvous([mockRendezvous(id: '1')]).deeplinkToRendezvous('22').store();

      // When
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, 0);

      // Then
      expect(viewModel.deeplinkRendezvousId, isNull);
    });
  });

  group('onRetry should trigger RequestRendezvousAction', () {
    void assertOn({required int pageOffset, required RendezvousPeriod expectedPeriod}) {
      // Given
      final store = StoreSpy();
      final viewModel = RendezvousListViewModel.create(store, thursday3thFebruary, pageOffset);

      // When
      viewModel.onRetry();

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(dispatchedAction, isA<RendezvousRequestAction>());
      if (dispatchedAction is RendezvousRequestAction) {
        expect(dispatchedAction.period, expectedPeriod);
      }
    }

    test("on past", () {
      assertOn(pageOffset: -1, expectedPeriod: RendezvousPeriod.PASSE);
    });

    test("on future", () {
      assertOn(pageOffset: 0, expectedPeriod: RendezvousPeriod.FUTUR);
      assertOn(pageOffset: 1, expectedPeriod: RendezvousPeriod.FUTUR);
      assertOn(pageOffset: 2, expectedPeriod: RendezvousPeriod.FUTUR);
      assertOn(pageOffset: 3, expectedPeriod: RendezvousPeriod.FUTUR);
      assertOn(pageOffset: 4, expectedPeriod: RendezvousPeriod.FUTUR);
      assertOn(pageOffset: 5, expectedPeriod: RendezvousPeriod.FUTUR);
    });
  });

  group('fetchRendezvous???', () {
    group('for past rendezvous', () {
      void assertOn({required int pageOffset, required bool hasFetchedPast, required bool shouldRequestPast}) {
        final msg = "$pageOffset "
            "& ${hasFetchedPast ? "fetched" : "not fetched"} "
            "-> ${shouldRequestPast ? "should request" : "should not request"}";
        test(msg, () {
          // Given
          final state = hasFetchedPast ? RendezvousState.successful([]) : RendezvousState.successfulFuture([]);
          final store = StoreSpy.withState(AppState.initialState().copyWith(rendezvousState: state));

          // When
          RendezvousListViewModel.fetchRendezvous(store, pageOffset);

          // Then
          if (shouldRequestPast) {
            final dispatchedAction = store.dispatchedAction;
            expect(dispatchedAction, isA<RendezvousRequestAction>());
            if (dispatchedAction is RendezvousRequestAction) {
              expect(dispatchedAction.period, RendezvousPeriod.PASSE);
            }
          } else {
            expect(store.dispatchedAction, isNull);
          }
        });
      }

      assertOn(pageOffset: -1, hasFetchedPast: true, shouldRequestPast: false);
      assertOn(pageOffset: -1, hasFetchedPast: false, shouldRequestPast: true);
    });

    group('for future rendezvous', () {
      void assertOn({required int pageOffset, required bool hasFetchedFuture, required bool shouldRequestFuture}) {
        final msg = "$pageOffset "
            "& ${hasFetchedFuture ? "fetched" : "not fetched"} "
            "-> ${shouldRequestFuture ? "should request" : "should not request"}";
        test(msg, () {
          // Given
          final state = hasFetchedFuture ? RendezvousState.successfulFuture([]) : RendezvousState.notInitialized();
          final store = StoreSpy.withState(AppState.initialState().copyWith(rendezvousState: state));

          // When
          RendezvousListViewModel.fetchRendezvous(store, pageOffset);

          // Then
          if (shouldRequestFuture) {
            final dispatchedAction = store.dispatchedAction;
            expect(dispatchedAction, isA<RendezvousRequestAction>());
            if (dispatchedAction is RendezvousRequestAction) {
              expect(dispatchedAction.period, RendezvousPeriod.FUTUR);
            }
          } else {
            expect(store.dispatchedAction, isNull);
          }
        });
      }

      assertOn(pageOffset: 0, hasFetchedFuture: false, shouldRequestFuture: true);
      assertOn(pageOffset: 1, hasFetchedFuture: false, shouldRequestFuture: true);
      assertOn(pageOffset: 2, hasFetchedFuture: false, shouldRequestFuture: true);
      assertOn(pageOffset: 3, hasFetchedFuture: false, shouldRequestFuture: true);
      assertOn(pageOffset: 4, hasFetchedFuture: false, shouldRequestFuture: true);
      assertOn(pageOffset: 5, hasFetchedFuture: false, shouldRequestFuture: true);
      assertOn(pageOffset: 0, hasFetchedFuture: true, shouldRequestFuture: false);
      assertOn(pageOffset: 1, hasFetchedFuture: true, shouldRequestFuture: false);
      assertOn(pageOffset: 2, hasFetchedFuture: true, shouldRequestFuture: false);
      assertOn(pageOffset: 3, hasFetchedFuture: true, shouldRequestFuture: false);
      assertOn(pageOffset: 4, hasFetchedFuture: true, shouldRequestFuture: false);
      assertOn(pageOffset: 5, hasFetchedFuture: true, shouldRequestFuture: false);
    });
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
