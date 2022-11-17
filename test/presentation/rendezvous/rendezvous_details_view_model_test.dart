import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_details_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/utils/platform.dart';
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
    expect(
        () => RendezvousDetailsViewModel.create(
              store: store,
              source: RendezvousStateSource.rendezvousList,
              rdvId: '1',
              platform: Platform.IOS,
            ),
        throwsException);
  });

  test('create when rendezvous state is successful but no rendezvous is matching ID throws exception', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        rendezvousState: RendezvousState.successfulFuture([mockRendezvous(id: '1')]),
      ),
    );

    // Then
    expect(
        () => RendezvousDetailsViewModel.create(
              store: store,
              source: RendezvousStateSource.rendezvousList,
              rdvId: '2',
              platform: Platform.IOS,
            ),
        throwsException);
  });

  group('create when rendezvous state is successful…', () {

    test('and date is neither today neither tomorrow', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1)));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.date, '01 mars 2022');
    });

    test('and date is today', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime.now()));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.date, 'Aujourd\'hui');
    });

    test('and date is tomorrow', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime.now().add(Duration(days: 1))));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.date, 'Demain');
    });

    test('and duration is null', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: null));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.hourAndDuration, '12:30');
    });

    test('and duration is less than one hour', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 30));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.hourAndDuration, '12:30 (30min)');
    });

    test('and duration is more than one hour', () {
      // Given
      final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 150));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.hourAndDuration, '12:30 (2h30)');
    });

    test('and conseiller is present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', withConseiller: true));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.conseillerPresenceLabel, 'Votre conseiller sera présent');
      expect(viewModel.conseillerPresenceColor, AppColors.secondary);
      expect(viewModel.withConseillerPresencePart, isTrue);
    });

    test('and conseiller is not present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', withConseiller: false));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.conseillerPresenceLabel, 'Votre conseiller ne sera pas présent');
      expect(viewModel.conseillerPresenceColor, AppColors.warning);
      expect(viewModel.withConseillerPresencePart, isTrue);
    });

    group('should hide conseiller presence', () {
      void assertConseillerIsHidden(String title, Rendezvous rdv) {
        test(title, () {
          // Given
          final store = _store(rdv);

          // When
          final viewModel = RendezvousDetailsViewModel.create(
            store: store,
            source: RendezvousStateSource.rendezvousList,
            rdvId: '1',
            platform: Platform.IOS,
          );

          // Then
          expect(viewModel.withConseillerPresencePart, isFalse);
        });
      }

      assertConseillerIsHidden(
        "with entretien individuel",
        mockRendezvous(
          id: '1',
          type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, ''),
          withConseiller: true,
        ),
      );

      assertConseillerIsHidden(
        "with prestation",
        mockRendezvous(
          id: '1',
          type: RendezvousType(RendezvousTypeCode.PRESTATION, ''),
          withConseiller: true,
        ),
      );

      assertConseillerIsHidden("without conseiller field", mockRendezvous(id: '1', withConseiller: null));
    });

    test('and comment is not set', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: null));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.comment, null);
    });

    test('and comment is set but empty', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: ''));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.comment, null);
      expect(viewModel.commentTitle, null);
    });

    test('and comment is set but blank', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: '   '));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.comment, null);
      expect(viewModel.commentTitle, null);
    });

    test('and comment is set and filled but conseiller is not set', () {
      // Given
      final store = _store(mockRendezvous(id: '1', comment: 'comment', conseiller: null));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

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
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.comment, 'comment');
      expect(viewModel.commentTitle, 'Commentaire de mon conseiller');
    });

    test('and address is set should properly format addressRedirectUri (on iOS)', () {
      // Given
      final store = _store(mockRendezvous(id: '1', address: 'Address 1'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.addressRedirectUri, Uri.parse("https://maps.apple.com/maps?q=Address+1"));
    });

    test('and address is set should properly format addressRedirectUri (on Android)', () {
      // Given
      final store = _store(mockRendezvous(id: '1', address: 'Address 1'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.ANDROID,
      );

      // Then
      expect(viewModel.addressRedirectUri, Uri.parse("geo:0,0?q=Address%201"));
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
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.modality, "Le rendez-vous se fera en visio");
      expect(viewModel.conseiller, "votre conseiller Nils Tavernier");
    });

    test('should display createur if present', () {
      // Given
      final store = _store(mockRendezvous(
        id: '1',
        withConseiller: true,
        createur: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
      ));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.createur, "Le rendez-vous a été programmé par votre conseiller précédent Nils Tavernier");
    });

    test('should display modality without conseiller', () {
      // Given
      final store = _store(mockRendezvous(id: '1', modality: "en visio", withConseiller: false));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.modality, "Le rendez-vous se fera en visio");
    });

    test('should not display empty modality', () {
      // Given
      final store = _store(mockRendezvous(id: '1', modality: null));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.modality, isNull);
    });

    test('should display whether rdv is annule or not', () {
      // Given
      final store = _store(mockRendezvous(id: '1', isAnnule: true));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.isAnnule, isTrue);
    });

    test('should display special visio modality', () {
      // Given
      final store = _store(mockRendezvous(id: '1', isInVisio: true, address: 'address'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.modality, 'Le rendez-vous se fera en visio. La visio sera disponible le jour du rendez-vous.');
    });

    test('should hide address informations on rendez-vous by visio', () {
      // Given
      final store = _store(mockRendezvous(id: '1', isInVisio: true, address: 'address'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.address, isNull);
      expect(viewModel.addressRedirectUri, isNull);
      expect(viewModel.organism, isNull);
    });

    test('should hide address informations on rendez-vous by phone', () {
      // Given
      final store = _store(mockRendezvous(id: '1', modality: "par téléphone", address: 'address'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.address, isNull);
      expect(viewModel.addressRedirectUri, isNull);
      expect(viewModel.organism, isNull);
    });

    test('should display inactive visio button if rdv is in visio but no link is present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', isInVisio: true, visioRedirectUrl: null));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.visioButtonState, VisioButtonState.INACTIVE);
    });

    test('should display active visio button if rdv is in visio and link is present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', isInVisio: true, visioRedirectUrl: 'url'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.visioButtonState, VisioButtonState.ACTIVE);
      expect(viewModel.visioRedirectUrl, 'url');
    });

    test('should display phone if present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', phone: 'phone'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.phone, 'Téléphone : phone');
    });

    test('should display theme and description if present', () {
      // Given
      final store = _store(mockRendezvous(id: '1', theme: 'theme', description: 'description'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.theme, 'theme');
      expect(viewModel.description, 'description');
      expect(viewModel.withDescriptionPart, isTrue);
    });

    test('should display description part even with just theme', () {
      // Given
      final store = _store(mockRendezvous(id: '1', theme: 'theme', description: 'description'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.withDescriptionPart, isTrue);
    });

    test('should display description part even with just description', () {
      // Given
      final store = _store(mockRendezvous(id: '1', description: 'description'));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.withDescriptionPart, isTrue);
    });

    test('should not display modality part if no relevant info', () {
      // Given
      final store = _store(mockRendezvous(
        id: '1',
        modality: null,
        address: null,
        phone: null,
        organism: null,
        isInVisio: false,
      ));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.withModalityPart, isFalse);
    });

    test('full view model test', () {
      // Given
      final store = _store(Rendezvous(
        id: '1',
        title: "Super atelier",
        date: DateTime(2022, 3, 1),
        duration: 30,
        modality: 'Sur place : Mission Locale',
        isInVisio: false,
        withConseiller: true,
        isAnnule: false,
        type: RendezvousType(RendezvousTypeCode.ATELIER, 'Atelier'),
        comment: 'comment',
        organism: 'organism',
        address: 'address',
        conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
      ));

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(
        viewModel,
        RendezvousDetailsViewModel(
          tag: "Atelier",
          greenTag: false,
          date: '01 mars 2022',
          hourAndDuration: '00:00 (30min)',
          conseillerPresenceLabel: 'Votre conseiller sera présent',
          conseillerPresenceColor: AppColors.secondary,
          isAnnule: false,
          withConseillerPresencePart: true,
          withDescriptionPart: false,
          withModalityPart: true,
          visioButtonState: VisioButtonState.HIDDEN,
          trackingPageName: 'rdv/atelier',
          modality: 'Le rendez-vous se fera sur place : Mission Locale',
          conseiller: 'votre conseiller Nils Tavernier',
          commentTitle: 'Commentaire de mon conseiller',
          title: 'Super atelier',
          comment: 'comment',
          organism: 'organism',
          address: 'address',
          addressRedirectUri: Uri.parse('https://maps.apple.com/maps?q=address'),
        ),
      );
    });

    test('when source is agenda should get rendezvous from agenda state', () {
      // Given
      final rendezvous = mockRendezvous(id: '1', description: 'description');
      final store = givenState().agenda(rendezvous: [rendezvous]).store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.agenda,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.description, 'description');
    });
  });

  group("tracking should be set correctly depending on rendezvous type", () {
    void assertTrackingPageName(Rendezvous rdv, String trackingPageName) {
      test("${rdv.type.code} -> $trackingPageName", () async {
        // Given
        final store = _store(rdv);

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.rendezvousList,
          rdvId: '1',
          platform: Platform.IOS,
        );

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
      mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.PRESTATION, '')),
      'rdv/prestation',
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
      rendezvousState: RendezvousState.successfulFuture([rendezvous]),
    ),
  );
}
