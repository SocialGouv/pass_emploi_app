import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when mon suivi state is not successful throws exception', () {
    // Given
    final store = givenState().loggedIn().copyWith(monSuiviState: MonSuiviFailureState()).store();

    // Then
    expect(() => RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1'), throwsException);
  });

  test('create when rendezvous state is successful but no rendezvous is matching ID throws exception', () {
    // Given
    final store = givenRendezvous(mockRendezvous(id: '1')).store();

    // Then
    expect(() => RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '2'), throwsException);
  });

  group('create when rendezvous state is successful and Rendezvous not empty…', () {
    test('should display precision in description if type is "Autre" and precision is set', () {
      // Given
      final store = givenRendezvous(mockRendezvous(
        id: '1',
        precision: 'Precision',
        type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'),
      )).store();

      // When
      final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

      // Then
      expect(viewModel.tag, "Autre");
      expect(viewModel.description, "Precision");
    });

    test('should display type label in tag if type is "Autre" and precision is not set', () {
      // Given
      final store = givenRendezvous(mockRendezvous(
        id: '1',
        precision: null,
        type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'),
      )).store();

      // When
      final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

      // Then
      expect(viewModel.tag, "Autre");
    });

    test('should display date without day', () {
      // Given
      final store = givenRendezvous(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 10, 20))).store();

      // When
      final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

      // Then
      expect(viewModel.dateTime, RendezVousDateTimeHour("10h20"));
    });

    group("place", () {
      test('should display modality with conseiller when source is pass emploi', () {
        // Given
        final store = givenRendezvous(mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          modality: "en visio",
          withConseiller: true,
          conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
        )).store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.place, "En visio avec Nils Tavernier");
      });

      test('should display modality without conseiller', () {
        // Given
        final store = givenRendezvous(mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          modality: "en visio",
          withConseiller: false,
        )).store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.place, "En visio");
      });

      test('should not display empty modality', () {
        // Given
        final store = givenRendezvous(mockRendezvous(id: '1', modality: null, withConseiller: false)).store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.place, isNull);
      });

      test('should display modality without conseiller when source is milo', () {
        // Given
        final store = givenRendezvous(mockRendezvous(
          id: '1',
          source: RendezvousSource.milo,
          modality: "en visio",
          withConseiller: true,
          conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
        )).store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.place, "En visio");
      });
    });

    test('should display whether rdv is annule or not', () {
      // Given
      final store = givenRendezvous(mockRendezvous(id: '1', isAnnule: true)).store();

      // When
      final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

      // Then
      expect(viewModel.isAnnule, isTrue);
    });

    test('should display empty title when rdv title is null', () {
      // Given
      final store = givenRendezvous(mockRendezvous(id: '1', title: null)).store();

      // When
      final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

      // Then
      expect(viewModel.title, "");
    });

    test('full view model test', () {
      // Given
      final store = givenRendezvous(Rendezvous(
        id: '1',
        source: RendezvousSource.passEmploi,
        date: DateTime(2021, 12, 23, 10, 20),
        title: "Super bio",
        duration: 60,
        modality: 'par téléphone',
        isInVisio: false,
        withConseiller: false,
        isAnnule: false,
        organism: 'Entreprise Bio Carburant',
        type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
      )).store();

      // When
      final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

      // Then
      expect(
        viewModel,
        RendezvousCardViewModel(
            id: '1',
            tag: 'Atelier',
            dateTime: RendezVousDateTimeHour("10h20"),
            inscriptionStatus: InscriptionStatus.hidden,
            isAnnule: false,
            title: 'Super bio',
            description: null,
            place: 'Par téléphone',
            nombreDePlacesRestantes: null),
      );
    });

    group('inscription status', () {
      test('should display isInscrit when source is from event list and rdv is inscrit', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: true,
        );
        final store = givenState().loggedIn().succeedEventList(animationsCollectives: [rdv]).store();

        // When
        final viewModel = RendezvousCardViewModel.create(
          store,
          RendezvousStateSource.eventListAnimationsCollectives,
          '1',
        );

        // Then
        expect(viewModel.inscriptionStatus, InscriptionStatus.inscrit);
      });

      test('should display notInscrit when source is from event list and rdv is not inscrit', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
        );
        final store = givenState().loggedIn().succeedEventList(animationsCollectives: [rdv]).store();

        // When
        final viewModel = RendezvousCardViewModel.create(
          store,
          RendezvousStateSource.eventListAnimationsCollectives,
          '1',
        );

        // Then
        expect(viewModel.inscriptionStatus, InscriptionStatus.notInscrit);
      });

      test('should display autoinscription when source is from event list and rdv has autoinscription', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          autoinscription: true,
          nombreDePlacesRestantes: 1,
        );
        final store = givenState().loggedIn().succeedEventList(animationsCollectives: [rdv]).store();

        // When
        final viewModel = RendezvousCardViewModel.create(
          store,
          RendezvousStateSource.eventListAnimationsCollectives,
          '1',
        );

        // Then
        expect(viewModel.inscriptionStatus, InscriptionStatus.autoinscription);
      });

      test('should hide inscription status when source is from event list and rdv is not inscrit', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
        );
        final store = givenState().loggedIn().succeedEventList(animationsCollectives: [rdv]).store();

        // When
        final viewModel = RendezvousCardViewModel.create(
          store,
          RendezvousStateSource.eventListAnimationsCollectives,
          '1',
        );

        // Then
        expect(viewModel.inscriptionStatus, InscriptionStatus.notInscrit);
      });

      test('should display full status when nombreDePlacesRestantes is 0 and rdv is not inscrit', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          nombreDePlacesRestantes: 0,
        );
        final store = givenState().loggedIn().succeedEventList(animationsCollectives: [rdv]).store();

        // When
        final viewModel = RendezvousCardViewModel.create(
          store,
          RendezvousStateSource.eventListAnimationsCollectives,
          '1',
        );

        // Then
        expect(viewModel.inscriptionStatus, InscriptionStatus.full);
      });
    });

    group('date and time', () {
      test('should return a full date and period when source is from evenements', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
        );
        final store = givenState().loggedIn().succeedEventList(animationsCollectives: [rdv]).store();

        // When
        final viewModel = RendezvousCardViewModel.create(
          store,
          RendezvousStateSource.eventListAnimationsCollectives,
          '1',
        );

        // Then
        expect(viewModel.dateTime, RendezVousDateTimeDate("23 décembre 2021, 10h20 - 11h20"));
      });

      test('should return a hour when source is from mon suivi', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
        );
        final store = givenState().loggedIn().monSuivi(monSuivi: mockMonSuivi(rendezvous: [rdv])).store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.dateTime, RendezVousDateTimeHour("10h20"));
      });
    });

    group('nombreDePlacesRestantes', () {
      test('should display nothing when nombreDePlacesRestantes is null', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
          nombreDePlacesRestantes: null,
        );
        final store = givenState() //
            .loggedIn()
            .monSuivi(monSuivi: mockMonSuivi(rendezvous: [rdv]))
            .store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.nombreDePlacesRestantes, null);
      });

      test('should display nothing when nombreDePlacesRestantes is 0', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
          nombreDePlacesRestantes: 0,
        );
        final store = givenState() //
            .loggedIn()
            .monSuivi(monSuivi: mockMonSuivi(rendezvous: [rdv]))
            .store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.nombreDePlacesRestantes, null);
      });

      test('should display singular string when nombreDePlacesRestantes is 1', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
          nombreDePlacesRestantes: 1,
        );
        final store = givenState() //
            .loggedIn()
            .monSuivi(monSuivi: mockMonSuivi(rendezvous: [rdv]))
            .store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.nombreDePlacesRestantes, "1 place restante");
      });

      test('should display plural string when nombreDePlacesRestantes is more than 1', () {
        // Given
        final rdv = mockRendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          estInscrit: false,
          date: DateTime(2021, 12, 23, 10, 20),
          duration: 60,
          nombreDePlacesRestantes: 10,
        );
        final store = givenState() //
            .loggedIn()
            .monSuivi(monSuivi: mockMonSuivi(rendezvous: [rdv]))
            .store();

        // When
        final viewModel = RendezvousCardViewModel.create(store, RendezvousStateSource.monSuivi, '1');

        // Then
        expect(viewModel.nombreDePlacesRestantes, "10 places restantes");
      });
    });
  });
}

AppState givenRendezvous(Rendezvous rendezvous) {
  return givenState() //
      .loggedIn()
      .monSuivi(monSuivi: mockMonSuivi(rendezvous: [rendezvous]));
}
