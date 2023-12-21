import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/service_civique/criteres_recherche_service_civique_contenu_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display CONTENT', () {
      // Given
      final store = givenState().initialRechercheServiceCiviqueState().store();

      // When
      final viewModel = CriteresRechercheServiceCiviqueContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test('when recherche status is initial loading should display LOADING', () {
      // Given
      final store = givenState().initialLoadingRechercheServiceCiviqueState().store();

      // When
      final viewModel = CriteresRechercheServiceCiviqueContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test('when recherche status is failure should display FAILURE', () {
      // Given
      final store = givenState().failureRechercheServiceCiviqueState().store();

      // When
      final viewModel = CriteresRechercheServiceCiviqueContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });
  });

  group('onSearchingRequest', () {
    test('on initial request should dispatch proper action without filtres', () {
      // Given
      final store = StoreSpy();
      final viewModel = CriteresRechercheServiceCiviqueContenuViewModel.create(store);

      // When
      viewModel.onSearchingRequest(mockLocation());

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(
        dispatchedAction,
        isA<RechercheRequestAction<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>>(),
      );
      expect(
        (dispatchedAction as RechercheRequestAction<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>)
            .request,
        RechercheRequest(
          ServiceCiviqueCriteresRecherche(location: mockLocation()),
          ServiceCiviqueFiltresRecherche.noFiltre(),
          1,
        ),
      );
    });

    group('on updated request', () {
      test('should dispatch proper action with previous filtres', () {
        // Given
        final startDate = DateTime(2022);
        final previousFiltres = ServiceCiviqueFiltresRecherche(distance: null, startDate: startDate, domain: null);
        final store = givenState().successRechercheServiceCiviqueStateWithRequest(filtres: previousFiltres).spyStore();
        final viewModel = CriteresRechercheServiceCiviqueContenuViewModel.create(store);

        // When
        viewModel.onSearchingRequest(mockLocation());

        // Then
        final dispatchedAction = store.dispatchedAction;
        expect(
          (dispatchedAction as RechercheRequestAction<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>)
              .request,
          RechercheRequest(
            ServiceCiviqueCriteresRecherche(location: mockLocation()),
            previousFiltres,
            1,
          ),
        );
      });

      test('if new location is null should dispatch proper action with previous filtres excluding distance', () {
        // Given
        final startDate = DateTime(2022);
        final previousFiltres = ServiceCiviqueFiltresRecherche(distance: 50, startDate: startDate, domain: null);
        final store = givenState().successRechercheServiceCiviqueStateWithRequest(filtres: previousFiltres).spyStore();
        final viewModel = CriteresRechercheServiceCiviqueContenuViewModel.create(store);

        // When
        viewModel.onSearchingRequest(null);

        // Then
        final dispatchedAction = store.dispatchedAction;
        expect(
          (dispatchedAction as RechercheRequestAction<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>)
              .request,
          RechercheRequest(
            ServiceCiviqueCriteresRecherche(location: null),
            ServiceCiviqueFiltresRecherche(distance: null, startDate: startDate, domain: null),
            1,
          ),
        );
      });
    });
  });
}
