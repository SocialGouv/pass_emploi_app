import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_details_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_setup.dart';

void main() {
  group('with RendezvousStateSource', () {
    test('create when rendezvous list state is not successful throws exception', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(rendezvousListState: RendezvousListState.loadingFuture()),
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

    test('create when rendezvous list state is successful but no rendezvous is matching ID throws exception', () {
      // Given
      final store = TestStoreFactory().initializeReduxStore(
        initialState: loggedInState().copyWith(
          rendezvousListState: RendezvousListState.successfulFuture(rendezvous: [mockRendezvous(id: '1')]),
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

    group('create when rendezvous list state is successful…', () {
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

      test('and dateDerniereMiseAJour is present', () {
        // Given
        final store = _storeNotUpToDate(mockRendezvous(id: '1'), DateTime(2022, 12, 25, 12, 30));

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.rendezvousList,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.withDateDerniereMiseAJour, "Dernière actualisation de vos rendez-vous le 25/12/2022 à 12h30");
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

        assertConseillerIsHidden("with source milo", mockRendezvous(id: '1', source: RendezvousSource.milo));
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

      test('should hide conseiller in modality when source is milo', () {
        // Given
        final store = _store(mockRendezvous(
          id: '1',
          source: RendezvousSource.milo,
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
        expect(viewModel.conseiller, null);
      });

      group("createur", () {
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

        test('should hide createur if source is milo', () {
          // Given
          final store = _store(mockRendezvous(
            id: '1',
            source: RendezvousSource.milo,
            withConseiller: true,
            conseiller: Conseiller(id: 'id', firstName: 'Nils', lastName: 'Tavernier'),
            createur: Conseiller(id: 'id', firstName: 'Système', lastName: 'Milo'),
          ));

          // When
          final viewModel = RendezvousDetailsViewModel.create(
            store: store,
            source: RendezvousStateSource.rendezvousList,
            rdvId: '1',
            platform: Platform.IOS,
          );

          // Then
          expect(viewModel.createur, null);
        });
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

      test('display session leader when source is session milo details', () {
        // Given
        final store = givenState().loggedInUser().withSuccessSessionMiloDetails().store();

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.sessionMiloDetails,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.withAnimateur, "SIMILO SIMILO");
      });

      group('Événements special display', () {
        late RendezvousDetailsViewModel viewModel;

        group('when événement is from Accueil > Evénements pouvant vous intéresser (user not inscrit)', () {
          setUp(() {
            final store = givenState()
                .withAccueilMiloSuccess(mockAccueilMilo(
                  evenements: [
                    mockRendezvous(
                      id: '1',
                      estInscrit: false,
                      createur: const Conseiller(id: 'id', firstName: 'F', lastName: 'L'),
                    )
                  ],
                ))
                .store();

            viewModel = RendezvousDetailsViewModel.create(
              store: store,
              source: RendezvousStateSource.accueilLesEvenements,
              rdvId: '1',
              platform: Platform.IOS,
            );
          });

          test('should display "Événement" page title', () {
            expect(viewModel.navbarTitle, "Événement");
          });

          test('should not display absent part', () {
            expect(viewModel.withIfAbsentPart, isFalse);
          });

          test('should not display créateur part', () {
            expect(viewModel.createur, isNull);
          });

          test('should be shareable', () {
            expect(viewModel.shareToConseillerSource, ChatPartageEventSource("1"));
            expect(viewModel.shareToConseillerButtonTitle, "Partager à mon conseiller");
          });
        });

        group('when événement is from Evénements list', () {
          group('and user is inscrit', () {
            setUp(() {
              final store = givenState().succeedEventList(
                animationsCollectives: [
                  mockRendezvous(
                    id: '1',
                    estInscrit: true,
                    createur: const Conseiller(id: 'id', firstName: 'F', lastName: 'L'),
                  )
                ],
              ).store();

              viewModel = RendezvousDetailsViewModel.create(
                store: store,
                source: RendezvousStateSource.eventListAnimationsCollectives,
                rdvId: '1',
                platform: Platform.IOS,
              );
            });

            test('should display "Mon rendez-vous" page title', () {
              expect(viewModel.navbarTitle, "Mon rendez-vous");
            });

            test('should display absent part', () {
              expect(viewModel.withIfAbsentPart, isTrue);
            });

            test('should be inscrit', () {
              expect(viewModel.isInscrit, isTrue);
            });

            test('should not display créateur part', () {
              expect(viewModel.createur, isNull);
            });

            test('should not be shareable', () {
              expect(viewModel.shareToConseillerSource, isNull);
              expect(viewModel.shareToConseillerButtonTitle, isNull);
            });
          });

          group('and user is not inscrit', () {
            setUp(() {
              final store = givenState().loggedInUser().succeedEventList(animationsCollectives: [
                mockRendezvous(
                  id: '1',
                  estInscrit: false,
                  createur: const Conseiller(id: 'id', firstName: 'F', lastName: 'L'),
                ),
              ]).store();

              viewModel = RendezvousDetailsViewModel.create(
                store: store,
                source: RendezvousStateSource.eventListAnimationsCollectives,
                rdvId: '1',
                platform: Platform.IOS,
              );
            });

            test('should display "Événement" page title', () {
              expect(viewModel.navbarTitle, "Événement");
            });

            test('should not display absent part', () {
              expect(viewModel.withIfAbsentPart, isFalse);
            });

            test('should not display créateur part', () {
              expect(viewModel.createur, isNull);
            });

            test('should not be inscrit', () {
              expect(viewModel.isInscrit, isFalse);
            });

            test('should be shareable', () {
              expect(viewModel.shareToConseillerSource, ChatPartageEventSource("1"));
              expect(viewModel.shareToConseillerButtonTitle, "Partager à mon conseiller");
            });
          });
        });
      });

      test('should be shareable if vm created from session milo details', () {
        // Given
        final store = givenState()
            .loggedInUser() //
            .withSuccessSessionMiloDetails(estInscrit: false)
            .store();

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.sessionMiloDetails,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.shareToConseillerSource, ChatPartageSessionMiloSource("1"));
        expect(viewModel.shareToConseillerButtonTitle, "Faire une demande d’inscription");
      });

      test('full view model test', () {
        // Given
        final store = _store(Rendezvous(
          id: '1',
          source: RendezvousSource.passEmploi,
          title: "Super atelier",
          date: DateTime(2022, 3, 1),
          duration: 30,
          modality: 'Sur place : Mission Locale',
          isInVisio: false,
          withConseiller: true,
          isAnnule: false,
          type: RendezvousType(RendezvousTypeCode.ENTRETIEN_PARTENAIRE, 'Entretien Partenaire'),
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
            displayState: DisplayState.CONTENT,
            navbarTitle: "Mon rendez-vous",
            id: "1",
            tag: "Entretien Partenaire",
            greenTag: false,
            date: '01 mars 2022',
            hourAndDuration: '00:00 (30min)',
            conseillerPresenceLabel: 'Votre conseiller sera présent',
            conseillerPresenceColor: AppColors.secondary,
            isInscrit: false,
            isAnnule: false,
            withConseillerPresencePart: true,
            withDescriptionPart: false,
            withModalityPart: true,
            withIfAbsentPart: true,
            visioButtonState: VisioButtonState.HIDDEN,
            onRetry: () => {},
            trackingPageName: 'rdv/detail',
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

      test('when source is accueil should get rendezvous from accueil state', () {
        // Given
        final store = givenState().withAccueilMiloSuccess().store();

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.accueilProchainRendezvous,
          rdvId: mockRendezvousMiloCV().id,
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.id, mockRendezvousMiloCV().id);
      });
    });

    group('create when source is from session milo details', () {
      test('should display session milo rendez vous', () {
        // Given
        final store = givenState()
            .loggedInUser() //
            .withSuccessSessionMiloDetails(
              dateDeDebut: DateTime(2022, 3, 1),
              dateDeFin: DateTime(2022, 3, 1),
            )
            .store();

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.sessionMiloDetails,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(
          viewModel,
          RendezvousDetailsViewModel(
              displayState: DisplayState.CONTENT,
              navbarTitle: "Mon rendez-vous",
              id: "1",
              tag: "Atelier",
              greenTag: false,
              date: '01 mars 2022',
              hourAndDuration: '00:00 (0min)',
              conseillerPresenceLabel: 'Votre conseiller ne sera pas présent',
              conseillerPresenceColor: AppColors.warning,
              isInscrit: true,
              isAnnule: false,
              withConseillerPresencePart: false,
              withDescriptionPart: true,
              withModalityPart: true,
              withIfAbsentPart: true,
              visioButtonState: VisioButtonState.HIDDEN,
              onRetry: () => {},
              commentTitle: 'Commentaire',
              title: 'ANIMATION COLLECTIVE POUR TEST - SESSION TEST',
              trackingPageName: "session_milo/detail",
              comment: 'Lorem ipsus',
              address: 'Paris',
              addressRedirectUri: Uri.parse('https://maps.apple.com/maps?q=Paris'),
              description: "--"),
        );
      });
    });
  });

  test('when session state is loading', () {
    // Given
    final store = givenState()
        .loggedInUser() //
        .withLoadingSessionMiloDetails()
        .store();

    // When
    final viewModel = RendezvousDetailsViewModel.create(
      store: store,
      source: RendezvousStateSource.sessionMiloDetails,
      rdvId: '1',
      platform: Platform.IOS,
    );

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  group('without RendezvousStateSource', () {
    test('when rendezvous state is loading', () {
      // Given
      final store = givenState()
          .loggedInUser() //
          .copyWith(rendezvousDetailsState: RendezvousDetailsLoadingState())
          .store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.noSource,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when rendezvous state is content', () {
      // Given
      final store = givenState()
          .loggedInUser() //
          .copyWith(rendezvousDetailsState: RendezvousDetailsSuccessState(mockRendezvous()))
          .store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.noSource,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('when rendezvous state is failure', () {
      // Given
      final store = givenState()
          .loggedInUser() //
          .copyWith(rendezvousDetailsState: RendezvousDetailsFailureState())
          .store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.noSource,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('when onRetry is performed RendezvousDetailsRequestAction is dispatched', () {
      // Given
      const rendezvousId = '1';
      final store = StoreSpy();
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.noSource,
        rdvId: rendezvousId,
        platform: Platform.IOS,
      );

      // When
      viewModel.onRetry();

      // Then
      expect(store.dispatchedAction is RendezvousDetailsRequestAction, isTrue);
      expect((store.dispatchedAction as RendezvousDetailsRequestAction).rendezvousId, rendezvousId);
    });
  });

  group("tracking when rendezvous…", () {
    test('source state is Session Milo Details should be track as a Session Milo', () {
      // Given
      final store = givenState().loggedInUser().withSuccessSessionMiloDetails().store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.sessionMiloDetails,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.trackingPageName, 'session_milo/detail');
    });

    test('is of type ATELIER should be track as an Animation Collective', () {
      // Given
      final rdv = mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ATELIER, ''));
      final store = givenState().loggedInUser().rendezvous(rendezvous: [rdv]).store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.trackingPageName, 'animation_collective/detail');
    });

    test('is of type INFORMATION_COLLECTIVE should be track as an Animation Collective', () {
      // Given
      final rdv = mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.INFORMATION_COLLECTIVE, ''));
      final store = givenState().loggedInUser().rendezvous(rendezvous: [rdv]).store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.trackingPageName, 'animation_collective/detail');
    });

    test('otherwise should be track as a Rendezvous', () {
      // Given
      final rdv = mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, ''));
      final store = givenState().loggedInUser().rendezvous(rendezvous: [rdv]).store();

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.rendezvousList,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.trackingPageName, 'rdv/detail');
    });
  });
}

Store<AppState> _store(Rendezvous rendezvous) {
  return givenState().loggedInUser().rendezvous(rendezvous: [rendezvous]).store();
}

Store<AppState> _storeNotUpToDate(Rendezvous rendezvous, DateTime dateDerniereMiseAJour) {
  return givenState()
      .loggedInUser()
      .rendezvous(rendezvous: [rendezvous], dateDerniereMiseAJour: dateDerniereMiseAJour) //
      .store();
}
