import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
  test('create when rendezvous state is not successful throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousLoadingState()),
    );

    // Then
    expect(() => RendezvousCardViewModel.create(store, '1'), throwsException);
  });

  test('create when rendezvous state is successful but no rendezvous is matching ID throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        rendezvousState: RendezvousSuccessState([mockRendezvous(id: '1')]),
      ),
    );

    // Then
    expect(() => RendezvousCardViewModel.create(store, '2'), throwsException);
  });

  group('create when rendezvous state is successful…', () {
    test('should display precision in tag if type is "Autre" and precision is set', () {
      // Given
      final store = _store(
        mockRendezvous(id: '1', precision: 'Precision', type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre')),
      );

      // When
      final viewModel = RendezvousCardViewModel.create(store, '1');

      // Then
      expect(viewModel.tag, "Precision");
    });

    test('should display type label in tag if type is "Autre" and precision is not set', () {
      // Given
      final store = _store(
        mockRendezvous(id: '1', precision: null, type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre')),
      );

      // When
      final viewModel = RendezvousCardViewModel.create(store, '1');

      // Then
      expect(viewModel.tag, "Autre");
    });

    test('should display date properly if date is today ', () {
      // Given
      final now = DateTime.now();
      final store = _store(mockRendezvous(id: '1', date: DateTime(now.year, now.month, now.day, 10, 20)));

      // When
      final viewModel = RendezvousCardViewModel.create(store, '1');

      // Then
      expect(viewModel.date, "Aujourd'hui à 10h20");
    });

    test('should display date properly if date is tomorrow ', () {
      // Given
      final tomorrow = DateTime.now().add(Duration(days: 1));
      final store = _store(
        mockRendezvous(id: '1', date: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 20)),
      );

      // When
      final viewModel = RendezvousCardViewModel.create(store, '1');

      // Then
      expect(viewModel.date, "Demain à 10h20");
    });

    test('should display date properly if date is neither today neither tomorrow', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 10, 20)));

      // When
      final viewModel = RendezvousCardViewModel.create(store, '1');

      // Then
      expect(viewModel.date, "Le 01/03/2022 à 10h20");
    });

    test('full view model test', () {
      // Given
      final store = _store(
        Rendezvous(
          id: '1',
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
          modality: 'par téléphone',
          withConseiller: false,
          organism: 'Entreprise Bio Carburant',
          type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
        ),
      );

      // When
      final viewModel = RendezvousCardViewModel.create(store, '1');

      // Then
      expect(
        viewModel,
        RendezvousCardViewModel(
          id: '1',
          tag: 'Atelier',
          date: 'Le 23/12/2021 à 10h20',
          title: 'Avec : Entreprise Bio Carburant',
          subtitle: 'Par téléphone',
        ),
      );
    });
  });
}

Store<AppState> _store(Rendezvous rendezvous) {
  return TestStoreFactory().initializeReduxStore(
    initialState: loggedInState().copyWith(
      rendezvousState: RendezvousSuccessState([rendezvous]),
    ),
  );
}
