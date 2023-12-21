import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/evenement_emploi/criteres_recherche_evenement_emploi_contenu_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display CONTENT', () {
      // Given
      final store = givenState().initialRechercheEvenementEmploiState().store();

      // When
      final viewModel = CriteresRechercheEvenementEmploiContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test('when recherche status is initial loading should display LOADING', () {
      // Given
      final store = givenState().initialLoadingRechercheEvenementEmploiState().store();

      // When
      final viewModel = CriteresRechercheEvenementEmploiContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test('when recherche status is failure should display FAILURE', () {
      // Given
      final store = givenState().failureRechercheEvenementEmploiState().store();

      // When
      final viewModel = CriteresRechercheEvenementEmploiContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });
  });

  group('onSearchingRequest', () {
    test('on initial request should dispatch proper action without filtres', () {
      // Given
      final store = StoreSpy();
      final viewModel = CriteresRechercheEvenementEmploiContenuViewModel.create(store);

      // When
      viewModel.onSearchingRequest(EvenementEmploiCriteresRecherche(
        location: mockLocation(),
        secteurActivite: SecteurActivite.agriculture,
      ));

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(
        dispatchedAction,
        isA<RechercheRequestAction<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>>(),
      );
      expect(
        (dispatchedAction as RechercheRequestAction<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>)
            .request,
        RechercheRequest(
          EvenementEmploiCriteresRecherche(location: mockLocation(), secteurActivite: SecteurActivite.agriculture),
          EvenementEmploiFiltresRecherche.noFiltre(),
          1,
        ),
      );
    });

    test('on updated request should dispatch proper action with previous filtres', () {
      // Given
      final previousFiltres = EvenementEmploiFiltresRecherche.noFiltre();
      final store = givenState().successRechercheEvenementEmploiStateWithRequest(filtres: previousFiltres).spyStore();
      final viewModel = CriteresRechercheEvenementEmploiContenuViewModel.create(store);

      // When
      viewModel.onSearchingRequest(EvenementEmploiCriteresRecherche(
        location: mockLocation(),
        secteurActivite: SecteurActivite.sante,
      ));

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(
        dispatchedAction,
        isA<RechercheRequestAction<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>>(),
      );
      expect(
        (dispatchedAction as RechercheRequestAction<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>)
            .request,
        RechercheRequest(
          EvenementEmploiCriteresRecherche(location: mockLocation(), secteurActivite: SecteurActivite.sante),
          EvenementEmploiFiltresRecherche.noFiltre(),
          1,
        ),
      );
    });
  });
}
