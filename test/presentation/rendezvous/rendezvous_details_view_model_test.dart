import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_bottom_sheet_view_model.dart';
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

void main() {
  group('with RendezvousStateSource', () {
    test('create when mon suivi state is not successful throws exception', () {
      // Given
      final store = givenState().store();

      // Then
      expect(
          () => RendezvousDetailsViewModel.create(
                store: store,
                source: RendezvousStateSource.monSuivi,
                rdvId: '1',
                platform: Platform.IOS,
              ),
          throwsException);
    });

    test('create when mon suivi state is successful but no rendezvous is matching ID throws exception', () {
      // Given
      final store = _store(mockRendezvous(id: '1'));

      // Then
      expect(
          () => RendezvousDetailsViewModel.create(
                store: store,
                source: RendezvousStateSource.monSuivi,
                rdvId: '2',
                platform: Platform.IOS,
              ),
          throwsException);
    });

    group('create when mon suivi state is successful…', () {
      test('and date is neither today neither tomorrow', () {
        // Given
        final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1)));

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.hourAndDuration, '12h30');
      });

      test('and duration is less than one hour', () {
        // Given
        final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 30));

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.monSuivi,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.hourAndDuration, '12h30 - 13h');
      });

      test('and duration is more than one hour', () {
        // Given
        final store = _store(mockRendezvous(id: '1', date: DateTime(2022, 3, 1, 12, 30), duration: 150));

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.monSuivi,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.hourAndDuration, '12h30 - 15h');
      });

      test('and conseiller is present', () {
        // Given
        final store = _store(mockRendezvous(id: '1', withConseiller: true));

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.monSuivi,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.conseillerPresenceLabel, 'Votre conseiller sera présent');
        expect(viewModel.conseillerPresenceColor, AppColors.success);
        expect(viewModel.withConseillerPresencePart, isTrue);
      });

      test('and conseiller is not present', () {
        // Given
        final store = _store(mockRendezvous(id: '1', withConseiller: false));

        // When
        final viewModel = RendezvousDetailsViewModel.create(
          store: store,
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
              source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.comment, 'comment');
        expect(viewModel.commentTitle, 'Description');
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
            source: RendezvousStateSource.monSuivi,
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
            source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
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
          source: RendezvousStateSource.monSuivi,
          rdvId: '1',
          platform: Platform.IOS,
        );

        // Then
        expect(viewModel.withModalityPart, isFalse);
      });

      test('display session leader when source is session milo details', () {
        // Given
        final store = givenState().loggedIn().withSuccessSessionMiloDetails().store();

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
                      date: DateTime(2100),
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
            expect(
              viewModel.shareToConseillerButton,
              isA<RendezVousShareToConseiller>()
                  .having(
                    (item) => item.label,
                    "label",
                    "Partager à mon conseiller",
                  )
                  .having(
                    (item) => item.chatPartageSource,
                    "source",
                    ChatPartageEventSource("1"),
                  ),
            );
          });

          test('should not be be shareable if rdv is in past', () {
            expect(
              viewModel.shareToConseillerButton,
              isA<RendezVousShareToConseiller>()
                  .having(
                    (item) => item.label,
                    "label",
                    "Partager à mon conseiller",
                  )
                  .having(
                    (item) => item.chatPartageSource,
                    "source",
                    ChatPartageEventSource("1"),
                  ),
            );
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
              expect(viewModel.shareToConseillerButton, isNull);
            });
          });

          group('and user is not inscrit', () {
            setUp(() {
              final store = givenState().loggedIn().succeedEventList(animationsCollectives: [
                mockRendezvous(
                  id: '1',
                  estInscrit: false,
                  createur: const Conseiller(id: 'id', firstName: 'F', lastName: 'L'),
                  date: DateTime(2100),
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
              expect(
                viewModel.shareToConseillerButton,
                isA<RendezVousShareToConseiller>()
                    .having(
                      (item) => item.label,
                      "label",
                      "Partager à mon conseiller",
                    )
                    .having(
                      (item) => item.chatPartageSource,
                      "source",
                      ChatPartageEventSource("1"),
                    ),
              );
            });
          });
        });
      });

      test('should be shareable if vm created from session milo details', () {
        // Given
        final store = givenState()
            .loggedIn() //
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
        expect(viewModel.shareToConseillerButton, isA<RendezVousShareToConseillerDemandeInscription>());
      });

      group('autoinscription available', () {
        final List<AutoInscriptionTest> autoInscriptionTests = [
          AutoInscriptionTest(
            title: "should not display autoinscription button if estInscrit is true",
            estInscrit: true,
            autoinscription: true,
            nombreDePlacesRestantes: 10,
            dateMaxInscription: DateTime(2050),
            expected: false,
          ),
          AutoInscriptionTest(
            title: "should not display autoinscription button if autoinscription is false",
            estInscrit: false,
            autoinscription: false,
            nombreDePlacesRestantes: 10,
            dateMaxInscription: DateTime(2050),
            expected: false,
          ),
          AutoInscriptionTest(
            title: "should not display autoinscription if nombreDePlacesRestantes is 0",
            estInscrit: false,
            autoinscription: true,
            nombreDePlacesRestantes: 0,
            dateMaxInscription: DateTime(2050),
            expected: false,
          ),
          AutoInscriptionTest(
            title: "should not display autoinscription if dateMaxInscription is in past",
            estInscrit: false,
            autoinscription: true,
            nombreDePlacesRestantes: 10,
            dateMaxInscription: DateTime(2024),
            expected: false,
          ),
          AutoInscriptionTest(
            title: "should display autoinscription",
            estInscrit: false,
            autoinscription: true,
            nombreDePlacesRestantes: 10,
            dateMaxInscription: DateTime(2050),
            expected: true,
          ),
          AutoInscriptionTest(
            title: "should display autoinscription if dateMaxInscription is null",
            estInscrit: false,
            autoinscription: true,
            nombreDePlacesRestantes: 10,
            dateMaxInscription: null,
            expected: true,
          ),
        ];

        for (final autoInscriptionTest in autoInscriptionTests) {
          test(autoInscriptionTest.title, () {
            // Given
            final store = givenState()
                .loggedIn() //
                .withSuccessSessionMiloDetails(
                  estInscrit: autoInscriptionTest.estInscrit,
                  autoinscription: autoInscriptionTest.autoinscription,
                  nombreDePlacesRestantes: autoInscriptionTest.nombreDePlacesRestantes,
                  dateMaxInscription: autoInscriptionTest.dateMaxInscription,
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
            expect(viewModel.shareToConseillerButton is RendezVousAutoInscription, autoInscriptionTest.expected);
          });
        }
      });

      test('when source is from milo and autoinscription is not available', () {
        // Given
        final store = givenState()
            .loggedIn() //
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
        expect(viewModel.shareToConseillerButton is RendezVousShareToConseillerDemandeInscription, true);
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
          source: RendezvousStateSource.monSuivi,
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
            date: '01 mars 2022',
            hourAndDuration: '00h - 00h30',
            conseillerPresenceLabel: 'Votre conseiller sera présent',
            conseillerPresenceColor: AppColors.success,
            isInscrit: false,
            isComplet: false,
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
            nombreDePlacesRestantes: null,
          ),
        );
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
            .loggedIn() //
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
            date: '01 mars 2022',
            hourAndDuration: '00h',
            conseillerPresenceLabel: 'Votre conseiller ne sera pas présent',
            conseillerPresenceColor: AppColors.warning,
            isInscrit: true,
            isComplet: false,
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
            description: "--",
            nombreDePlacesRestantes: null,
          ),
        );
      });
    });
  });

  test('when session state is loading', () {
    // Given
    final store = givenState()
        .loggedIn() //
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
          .loggedIn() //
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
          .loggedIn() //
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
          .loggedIn() //
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
      final store = givenState().loggedIn().withSuccessSessionMiloDetails().store();

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
      final store = _store(rdv);

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.trackingPageName, 'animation_collective/detail');
    });

    test('is of type INFORMATION_COLLECTIVE should be track as an Animation Collective', () {
      // Given
      final rdv = mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.INFORMATION_COLLECTIVE, ''));
      final store = _store(rdv);

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.trackingPageName, 'animation_collective/detail');
    });

    test('otherwise should be track as a Rendezvous', () {
      // Given
      final rdv = mockRendezvous(id: '1', type: RendezvousType(RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER, ''));
      final store = _store(rdv);

      // When
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.trackingPageName, 'rdv/detail');
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
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

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
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

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
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

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
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.nombreDePlacesRestantes, "10 places restantes");
    });

    test('should display isComplet when user is not inscrit and nombre de places restantes is 0', () {
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
      final viewModel = RendezvousDetailsViewModel.create(
        store: store,
        source: RendezvousStateSource.monSuivi,
        rdvId: '1',
        platform: Platform.IOS,
      );

      // Then
      expect(viewModel.isComplet, true);
    });
  });
}

Store<AppState> _store(Rendezvous rendezvous) => _storeNotUpToDate(rendezvous, null);

Store<AppState> _storeNotUpToDate(Rendezvous rendezvous, DateTime? dateDerniereMiseAJour) {
  return givenState()
      .loggedIn()
      .monSuivi(
        monSuivi: mockMonSuivi(
          rendezvous: [rendezvous],
          dateDerniereMiseAJourPoleEmploi: dateDerniereMiseAJour,
        ),
      )
      .store();
}

class AutoInscriptionTest {
  final String title;
  final bool estInscrit;
  final bool autoinscription;
  final int? nombreDePlacesRestantes;
  final DateTime? dateMaxInscription;
  final bool expected;

  AutoInscriptionTest({
    required this.title,
    required this.estInscrit,
    required this.autoinscription,
    required this.nombreDePlacesRestantes,
    required this.dateMaxInscription,
    required this.expected,
  });
}
