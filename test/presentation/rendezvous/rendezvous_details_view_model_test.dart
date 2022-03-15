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
        rendezvousState: RendezvousSuccessState([
          Rendezvous(
            id: '1',
            date: DateTime.now(),
            duration: 60,
            modality: '',
            withConseiller: false,
            type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
          ),
        ]),
      ),
    );

    // Then
    expect(() => RendezvousDetailsViewModel.create(store, '2'), throwsException);
  });

  test('create when rendezvous state is successful', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        rendezvousState: RendezvousSuccessState([
          Rendezvous(
            id: '1',
            date: DateTime(2021, 12, 23, 10, 20),
            comment: '',
            duration: 60,
            modality: 'Par téléphone',
            withConseiller: false,
            organism: 'Entreprise Bio Carburant',
            type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
          )
        ]),
      ),
    );

    // When
    final viewModel = RendezvousDetailsViewModel.create(store, '1');

    // Then
    expect(viewModel.title, 'Atelier');
  });
}
