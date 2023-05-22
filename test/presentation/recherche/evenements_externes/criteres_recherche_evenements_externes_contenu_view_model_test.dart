import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/evenements_externes/criteres_recherche_evenements_externes_contenu_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display CONTENT', () {
      // Given
      final store = givenState().initialRechercheEvenementsExternesState().store();

      // When
      final viewModel = CriteresRechercheEvenementsExternesContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('when recherche status is initial loading should display LOADING', () {
      // Given
      final store = givenState().initialLoadingRechercheEvenementsExternesState().store();

      // When
      final viewModel = CriteresRechercheEvenementsExternesContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when recherche status is failure should display FAILURE', () {
      // Given
      final store = givenState().failureRechercheEvenementsExternesState().store();

      // When
      final viewModel = CriteresRechercheEvenementsExternesContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });

  group('onSearchingRequest', () {
    test('on initial request should dispatch proper action without filtres', () {
      // Given
      final store = StoreSpy();
      final viewModel = CriteresRechercheEvenementsExternesContenuViewModel.create(store);

      // When
      viewModel.onSearchingRequest(mockLocation());

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(
        dispatchedAction,
        isA<RechercheRequestAction<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche>>(),
      );
      expect(
        (dispatchedAction
                as RechercheRequestAction<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche>)
            .request,
        RechercheRequest(
          EvenementsExternesCriteresRecherche(location: mockLocation()),
          EvenementsExternesFiltresRecherche(),
          1,
        ),
      );
    });

    test('on updated request should dispatch proper action with previous filtres', () {
      // Given
      final previousFiltres = EvenementsExternesFiltresRecherche();
      final store =
          givenState().successRechercheEvenementsExternesStateWithRequest(filtres: previousFiltres).spyStore();
      final viewModel = CriteresRechercheEvenementsExternesContenuViewModel.create(store);

      // When
      viewModel.onSearchingRequest(mockLocation());

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(
        dispatchedAction,
        isA<RechercheRequestAction<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche>>(),
      );
      expect(
        (dispatchedAction
                as RechercheRequestAction<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche>)
            .request,
        RechercheRequest(
          EvenementsExternesCriteresRecherche(location: mockLocation()),
          EvenementsExternesFiltresRecherche(),
          1,
        ),
      );
    });
  });
}
