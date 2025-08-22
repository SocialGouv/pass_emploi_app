import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_filtres_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group("displayState", () {
    test("create when search state is success should display success", () {
      // Given
      final store = givenState().successRechercheImmersionState().store();

      // When
      final viewModel = ImmersionFiltresViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test("create when search state is loading should display loading", () {
      // Given
      final store = givenState().updateLoadingRechercheImmersionState().store();

      // When
      final viewModel = ImmersionFiltresViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test("create when search state is failure should display failure", () {
      // Given
      final store = givenState().failureRechercheImmersionState().store();

      // When
      final viewModel = ImmersionFiltresViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
      expect(viewModel.errorMessage, "Une erreur est survenue. Veuillez réessayer");
    });
  });

  test("create when state has no filtre should set distance to 10km", () {
    // Given
    final store = givenState().successRechercheImmersionState().store();

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 10);
  });

  test("create when state distance filtre set should set distance", () {
    // Given

    final store = givenState()
        .successRechercheImmersionStateWithRequest(
          criteres: ImmersionCriteresRecherche(metier: mockMetier(), location: mockLocation()),
          filtres: ImmersionFiltresRecherche.distance(20),
        )
        .store();

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 20);
  });

  test("updateFiltres should map view model input into action", () {
    // Given
    final store = StoreSpy();

    final viewModel = ImmersionFiltresViewModel.create(store);
    // When

    viewModel.updateFiltres(
      20,
    );

    // Then
    expect(store.dispatchedAction, isA<RechercheUpdateFiltresAction<ImmersionFiltresRecherche>>());
    final action = store.dispatchedAction as RechercheUpdateFiltresAction<ImmersionFiltresRecherche>;
    expect(action.filtres.distance, 20);
  });
}
