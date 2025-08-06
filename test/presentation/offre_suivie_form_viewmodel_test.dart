import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/offres_suivies/offres_suivies_state.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/offre_suivie.dart';
import 'package:pass_emploi_app/presentation/offre_suivie_form_viewmodel.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';
import '../features/mon_suivi/mon_suivi_test.dart';

void main() {
  final offre = mockOffreEmploiDetails();
  final offreId = offre.id;
  group('OffreSuivieFormViewmodel', () {
    group('home page', () {
      test('should show offre suivie', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          // Given
          final store = givenState() //
              .loggedInPoleEmploiUser()
              .offreEmploiDetailsSuccess()
              .copyWith(
                offresSuiviesState: OffresSuiviesState(
                  offresSuivies: [
                    OffreSuivie(
                      dateConsultation: DateTime(2023),
                      offreDto: OffreEmploiDto(offre.toOffreEmploi),
                    ),
                  ],
                ),
              )
              .store();

          // When
          final viewModel = OffreSuivieFormViewmodel.create(store, offreId, true);

          // Then
          expect(viewModel.dateConsultation, "Vous avez consulté cette offre il y a 409 jours");
          expect(viewModel.offreLien, "Technicien / Technicienne d'installation de réseaux câblés  (H/F)");
          expect(viewModel.showConfirmation, false);
          expect(viewModel.confirmationMessage, null);
        });
      });

      test('should show offre suivie confirmation', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          // Given
          final store = givenState() //
              .loggedInPoleEmploiUser()
              .offreEmploiDetailsSuccess()
              .copyWith(
                offresSuiviesState: OffresSuiviesState(
                  offresSuivies: [
                    OffreSuivie(
                      dateConsultation: DateTime(2023),
                      offreDto: OffreEmploiDto(offre.toOffreEmploi),
                    ),
                  ],
                  confirmationOffre: OffreSuivie(
                    dateConsultation: DateTime(2025),
                    offreDto: OffreEmploiDto(
                      mockOffreEmploiDetails().toOffreEmploi,
                    ),
                  ),
                ),
              )
              .store();

          // When
          final viewModel = OffreSuivieFormViewmodel.create(store, offreId, true);

          // Then
          expect(viewModel.dateConsultation, "Vous avez consulté cette offre il y a 409 jours");
          expect(viewModel.offreLien, "Technicien / Technicienne d'installation de réseaux câblés  (H/F)");
          expect(viewModel.showConfirmation, true);
          expect(viewModel.confirmationMessage, null);
          expect(viewModel.confirmationButton, 'Voir l’offre suivante');
        });
      });

      test('should show offre suivie confirmation when in favoris', () {
        withClock(Clock.fixed(mercredi14Fevrier12h00), () {
          // Given
          final store = givenState() //
              .loggedInPoleEmploiUser()
              .offreEmploiDetailsSuccess()
              .copyWith(
                offreEmploiFavorisIdsState: FavoriIdsState.success({FavoriDto(mockOffreEmploiDetails().id)}),
              )
              .copyWith(
                offresSuiviesState: OffresSuiviesState(
                  offresSuivies: [
                    OffreSuivie(
                      dateConsultation: DateTime(2023),
                      offreDto: OffreEmploiDto(offre.toOffreEmploi),
                    ),
                  ],
                  confirmationOffre: OffreSuivie(
                    dateConsultation: DateTime(2025),
                    offreDto: OffreEmploiDto(
                      mockOffreEmploiDetails().toOffreEmploi,
                    ),
                  ),
                ),
              )
              .store();

          // When
          final viewModel = OffreSuivieFormViewmodel.create(store, offreId, true);

          // Then
          expect(viewModel.dateConsultation, "Vous avez consulté cette offre il y a 409 jours");
          expect(viewModel.offreLien, "Technicien / Technicienne d'installation de réseaux câblés  (H/F)");
          expect(viewModel.showConfirmation, true);
          expect(viewModel.confirmationMessage, 'Souhaitez-vous créer la démarche ? ');
          expect(viewModel.confirmationButton, 'Voir l’offre suivante');
        });
      });
    });
  });
}
