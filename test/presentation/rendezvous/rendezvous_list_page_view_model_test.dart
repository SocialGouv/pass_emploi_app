import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_list_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../utils/test_setup.dart';

main() {
  test('create when rendezvous state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousLoadingState()),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is not initialized should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousNotInitializedState()),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when rendezvous state is a failure should display failure', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousFailureState()),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  group('create when rendezvous state is success…', () {
    test('with rendezvous should display them and sort them by reverse chronological order', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            Rendezvous(
              id: '1',
              date: DateTime(2022, 12, 23, 10, 20),
              title: 'title1',
              comment: '',
              duration: 60,
              modality: 'Par téléphone',
              withConseiller: false,
              type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'),
            ),
            Rendezvous(
              id: '2',
              date: DateTime(2022, 12, 24, 13, 40),
              title: 'title2',
              comment: 'comment2',
              duration: 30,
              modality: 'À l\'agence',
              withConseiller: false,
              type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'),
            ),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items.length, 2);

      expect(
        viewModel.items[0],
        RendezvousCardViewModel(
          id: '2',
          title: 'title2',
          subtitle: 'À l\'agence',
          dateAndHour: '24/12/2022 à 13:40',
          dateWithoutHour: '24 décembre 2022',
          hourAndDuration: '13:40 (30min)',
          withComment: true,
          comment: 'comment2',
          modality: 'Le rendez-vous se fera à l\'agence',
        ),
      );
      expect(
        viewModel.items[1],
        RendezvousCardViewModel(
          id: '1',
          title: 'title1',
          subtitle: 'Par téléphone',
          dateAndHour: '23/12/2022 à 10:20',
          dateWithoutHour: '23 décembre 2022',
          hourAndDuration: '10:20 (1h)',
          withComment: false,
          comment: '',
          modality: 'Le rendez-vous se fera par téléphone',
        ),
      );
    });

    test('with rendezvous and coming from deeplink', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now(), '1'),
          rendezvousState: RendezvousSuccessState([
            Rendezvous(
              id: '1',
              date: DateTime(2022, 12, 23, 10, 20),
              title: 'title1',
              comment: '',
              duration: 60,
              modality: 'Par téléphone',
              withConseiller: false,
              type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'),
            )
          ]),
        ),
      );

      // When
      final viewModel = RendezvousListPageViewModel.create(store);

      // Then
      final rdv = viewModel.deeplinkRendezvous;
      expect(rdv != null, isTrue);
      expect(rdv!.title, 'title1');
      expect(rdv.subtitle, 'Par téléphone');
      expect(rdv.dateAndHour, '23/12/2022 à 10:20');
      expect(rdv.dateWithoutHour, '23 décembre 2022');
      expect(rdv.hourAndDuration, '10:20 (1h)');
      expect(rdv.withComment, false);
      expect(rdv.modality, 'Le rendez-vous se fera par téléphone');
    });

    test('without rendezvous should display an empty content', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(rendezvousState: RendezvousSuccessState([])),
      );

      // When
      final viewModel = RendezvousListPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
      expect(viewModel.items.length, 0);
    });
  });

  test('onRetry should trigger a RequestRendezvousAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = RendezvousListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<RendezvousRequestAction>());
  });
}
