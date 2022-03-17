import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/utils/platform.dart';
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
    expect(() => RendezvousDetailsViewModel.create(store, '1', Platform.IOS), throwsException);
  });

  test('create when rendezvous state is successful but no rendezvous is matching ID throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        rendezvousState: RendezvousSuccessState([mockRendezvous(id: '1')]),
      ),
    );

    // Then
    expect(() => RendezvousDetailsViewModel.create(store, '2', Platform.IOS), throwsException);
  });

  group('create when rendezvous state is successful…', () {
    test('and type code is not "Autre" should set type label as titre', () {
      // Given
      final store = _store(mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier')));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.title, 'Atelier');
    });

    test('and type code is "Autre" but precision is not set should set type label as titre', () {
      // Given
      final store = _store(
        mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'), precision: null),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.title, 'Autre');
    });

    test('and type code is "Autre" and precision is set should set precision as titre', () {
      // Given
      final store = _store(
        mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.AUTRE, 'Autre'), precision: 'Precision'),
      );

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.title, 'Precision');
    });

    test('and date is neither today neither tomorrow', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1)));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.date, '01 mars 2022');
    });

    test('and date is today', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime.now()));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.date, 'Aujourd\'hui');
    });

    test('and date is tomorrow', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime.now().add(Duration(days: 1))));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.date, 'Demain');
    });

    test('and duration is less than one hour', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 30));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.hourAndDuration, '12:30 (30min)');
    });

    test('and duration is more than one hour', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 150));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.hourAndDuration, '12:30 (2h30)');
    });

    test('and conseiller is present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', withConseiller: true));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.conseillerPresenceLabel, 'Votre conseiller sera présent');
      expect(viewModel.conseillerPresenceColor, AppColors.secondary);
    });

    test('and conseiller is not present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', withConseiller: false));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.conseillerPresenceLabel, 'Votre conseiller ne sera pas présent');
      expect(viewModel.conseillerPresenceColor, AppColors.warning);
    });

    test('and comment is not set', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: null));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.comment, null);
    });

    test('and comment is set but empty', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: ''));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.comment, null);
      expect(viewModel.commentTitle, null);
    });

    test('and comment is set but blank', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: '   '));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.comment, null);
      expect(viewModel.commentTitle, null);
    });

    test('and comment is set and filled but conseiller is not set', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: 'comment', conseiller: null));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.comment, 'comment');
      expect(viewModel.commentTitle, 'Commentaire de votre conseiller');
    });

    test('and comment is set and filled and conseiller is set', () {
      // Given
      final store = _store(mockRendezvous(
        id: '1',
        comment: 'comment',
        conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
      ));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.comment, 'comment');
      expect(viewModel.commentTitle, 'Commentaire de Nils');
    });

    test('and address is set should properly format addressRedirectUri (on iOS)', () {
      // Given
      final store = _store(mockRendezvous(id: '1', address: 'Address 1'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.addressRedirectUri, Uri.parse("https://maps.apple.com/maps?q=Address+1"));
    });

    test('and address is set should properly format addressRedirectUri (on Android)', () {
      // Given
      final store = _store(mockRendezvous(id: '1', address: 'Address 1'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.ANDROID);

      // Then
      expect(viewModel.addressRedirectUri, Uri.parse("geo:0,0?q=Address%201"));
    });

    test('should display modality with conseiller if conseiller is present', () {
      // Given
      final store = _store(mockRendezvous(
        id: '1',
        modality: "en visio",
        withConseiller: true,
        conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
      ));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(viewModel.modality, "Le rendez-vous se fera en visio avec Nils Tavernier");
    });

    test('full view model test', () {
      // Given
      final store = _store(Rendezvous(
        id: '1',
        date: DateTime(2022, 3, 1),
        duration: 30,
        modality: 'Sur place : Mission Locale',
        withConseiller: true,
        type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
        comment: 'comment',
        organism: 'organism',
        address: 'address',
        conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
      ));

      // When
      final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

      // Then
      expect(
        viewModel,
        RendezvousDetailsViewModel(
          title: 'Atelier',
          date: '01 mars 2022',
          hourAndDuration: '00:00 (30min)',
          conseillerPresenceLabel: 'Votre conseiller sera présent',
          conseillerPresenceColor: AppColors.secondary,
          trackingPageName: 'rdv/atelier',
          modality: 'Le rendez-vous se fera sur place : Mission Locale avec Nils Tavernier',
          commentTitle: 'Commentaire de Nils',
          comment: 'comment',
          organism: 'organism',
          address: 'address',
          addressRedirectUri: Uri.parse('https://maps.apple.com/maps?q=address'),
        ),
      );
    });
  });

  group("tracking should be set correctly depending on rendezvous type", () {
    void assertTrackingPageName(Rendezvous rdv, String trackingPageName) {
      test("${rdv.type.code} -> $trackingPageName", () async {
        // Given
        final store = _store(rdv);

        // When
        final viewModel = RendezvousDetailsViewModel.create(store, '1', Platform.IOS);

        // Then
        expect(viewModel.trackingPageName, trackingPageName);
      });
    }

    assertTrackingPageName(
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ACTIVITE_EXTERIEURES, '')),
      'rdv/activites-exterieures',
    );

    assertTrackingPageName(
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ATELIER, '')),
      'rdv/atelier',
    );

    assertTrackingPageName(
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, '')),
      'rdv/entretien-individuel',
    );

    assertTrackingPageName(
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ENTRETIEN_PARTENAIRE, '')),
      'rdv/entretien-partenaire',
    );

    assertTrackingPageName(
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.INFORMATION_COLLECTIVE, '')),
      'rdv/information-collective',
    );

    assertTrackingPageName(
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.VISITE, '')),
      'rdv/visite',
    );

    assertTrackingPageName(
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.AUTRE, '')),
      'rdv/autre',
    );
  });
}

Store<AppState> _store(Rendezvous rendezvous) {
  return TestStoreFactory().initializeReduxStore(
    initialState: loggedInState().copyWith(
      rendezvousState: RendezvousSuccessState([rendezvous]),
    ),
  );
}
