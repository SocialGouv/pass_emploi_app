import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_details_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
  test('create when rendezvous state is not successful throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousLoadingState()),
    );

    // Then
    expect(() => RendezvousDetailsViewModel.create(store, '1'), throwsException);
  });

  test('create when rendezvous state is successful but no rendezvous is matching ID throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        rendezvousState: RendezvousSuccessState([mockRendezvous(id: '1')]),
      ),
    );

    // Then
    expect(() => RendezvousDetailsViewModel.create(store, '2'), throwsException);
  });

  group('create when rendezvous state is successful…', () {
    test('and type code is not "Autre" should set type label as titre', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier')),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.title, 'Atelier');
    });

    test('and type code is "Autre" but precision is not set should set type label as titre', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'), precision: null),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.title, 'Autre');
    });

    test('and type code is "Autre" and precision is set should set precision as titre', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'), precision: 'Precision'),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.title, 'Precision');
    });

    test('and date is neither today neither tomorrow', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', date: DateTime(2022, 3, 1)),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.date, '01 mars 2022');
    });

    test('and date is today', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', date: DateTime.now()),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.date, 'Aujourd\'hui');
    });

    test('and date is tomorrow', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', date: DateTime.now().add(Duration(days: 1))),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.date, 'Demain');
    });

    test('and duration is less than one hour', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 30),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.hourAndDuration, '12:30 (30min)');
    });

    test('and duration is more than one hour', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousState: RendezvousSuccessState([
            mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 150),
          ]),
        ),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1');

      // Then
      expect(viewModel.hourAndDuration, '12:30 (2h30)');
    });
  });
}
