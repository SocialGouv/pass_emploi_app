import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when rendezvous state is not successful throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(rendezvousState: RendezvousState.loadingFuture()),
    );

    // Then
    expect(() => RendezvousCardViewModel.createFromRendezvousState(store, '1'), throwsException);
  });

  test('create when rendezvous state is successful but no rendezvous is matching ID throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        rendezvousState: RendezvousState.successfulFuture([mockRendezvous(id: '1')]),
      ),
    );

    // Then
    expect(() => RendezvousCardViewModel.createFromRendezvousState(store, '2'), throwsException);
  });

  group('create when rendezvous state is successful…', () {
    test('should display precision in tag if type is "Autre" and precision is set', () {
      // Given
      final store = _store(
        mockRendezvous(id: '1', precision: 'Precision', type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre')),
      );

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.tag, "Precision");
    });

    test('should display type label in tag if type is "Autre" and precision is not set', () {
      // Given
      final store = _store(
        mockRendezvous(id: '1', precision: null, type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre')),
      );

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.tag, "Autre");
    });

    test('should display date properly if date is today ', () {
      // Given
      final now = DateTime.now();
      final store = _store(mockRendezvous(id: '1', date: DateTime(now.year, now.month, now.day, 10, 20)));

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

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
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.date, "Demain à 10h20");
    });

    test('should display date properly if date is neither today neither tomorrow', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 10, 20)));

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.date, "Le 01/03/2022 à 10h20");
    });

    test('should display modality with conseiller', () {
      // Given
      final store = _store(mockRendezvous(
        id: '1',
        modality: "en visio",
        withConseiller: true,
        conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
      ));

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.subtitle, "En visio avec Nils Tavernier");
    });

    test('should display modality without conseiller', () {
      // Given
      final store = _store(mockRendezvous(id: '1', modality: "en visio", withConseiller: false));

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.subtitle, "En visio");
    });

    test('should not display empty modality', () {
      // Given
      final store = _store(mockRendezvous(id: '1', modality: null, withConseiller: false));

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.subtitle, isNull);
    });

    test('should display whether rdv is annule or not', () {
      // Given
      final store = _store(mockRendezvous(id: '1', isAnnule: true));

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(viewModel.isAnnule, isTrue);
    });

    test('full view model test from rendezvous', () {
      // Given
      final store = _store(
        Rendezvous(
          id: '1',
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
          modality: 'par téléphone',
          isInVisio: false,
          withConseiller: false,
          isAnnule: false,
          organism: 'Entreprise Bio Carburant',
          type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
        ),
      );

      // When
      final viewModel = RendezvousCardViewModel.createFromRendezvousState(store, '1');

      // Then
      expect(
        viewModel,
        RendezvousCardViewModel(
          id: '1',
          tag: 'Atelier',
          date: 'Le 23/12/2021 à 10h20',
          isAnnule: false,
          title: 'Avec : Entreprise Bio Carburant',
          subtitle: 'Par téléphone',
          greenTag: false,
        ),
      );
    });

    test('full view model test from agenda', () {
      // Given
      final rdv = Rendezvous(
          id: '1',
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
          modality: 'par téléphone',
          isInVisio: false,
          withConseiller: false,
          isAnnule: false,
          organism: 'Entreprise Bio Carburant',
          type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
      );
      final store = givenState().loggedInUser().agenda(actions: [], rendezvous: [rdv]).store();

      // When
      final viewModel = RendezvousCardViewModel.createFromAgendaState(store, '1');

      // Then
      expect(
        viewModel,
        RendezvousCardViewModel(
          id: '1',
          tag: 'Atelier',
          date: 'Le 23/12/2021 à 10h20',
          isAnnule: false,
          title: 'Avec : Entreprise Bio Carburant',
          subtitle: 'Par téléphone',
          greenTag: false,
        ),
      );
    });
  });
}

Store<AppState> _store(Rendezvous rendezvous) {
  return TestStoreFactory().initializeReduxStore(
    initialState: loggedInState().copyWith(
      rendezvousState: RendezvousState.successfulFuture([rendezvous]),
    ),
  );
}
