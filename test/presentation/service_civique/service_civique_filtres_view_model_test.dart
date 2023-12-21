import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group("displayState", () {
    test("create when search state is success should display success", () {
      // Given
      final store = givenState().successRechercheServiceCiviqueState().store();

      // When
      final viewModel = ServiceCiviqueFiltresViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test("create when search state is loading should display loading", () {
      // Given
      final store = givenState().updateLoadingRechercheServiceCiviqueState().store();

      // When
      final viewModel = ServiceCiviqueFiltresViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test("create when search state is failure should display failure", () {
      // Given
      final store = givenState().failureRechercheServiceCiviqueState().store();

      // When
      final viewModel = ServiceCiviqueFiltresViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });
  });

  test("create when state is result should set display to result with default distance, domain and date", () {
    // Given
    final state = givenState().successRechercheServiceCiviqueStateWithRequest(
      criteres: ServiceCiviqueCriteresRecherche(location: mockLocation()),
      filtres: ServiceCiviqueFiltresRecherche.noFiltre(),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.contenu);
    expect(viewModel.initialDistanceValue, 10);
    expect(viewModel.initialDomainValue, Domaine.all);
    expect(viewModel.initialStartDateValue, null);
  });

  test("create when state is result should set display to result with custom distance, domain and date", () {
    // Given
    final state = givenState().successRechercheServiceCiviqueStateWithRequest(
      criteres: ServiceCiviqueCriteresRecherche(location: mockCommuneLocation(lat: 12, lon: 12)),
      filtres: ServiceCiviqueFiltresRecherche(
        distance: 30,
        domain: Domaine.fromTag("solidarite-insertion"),
        startDate: DateTime(2023),
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.contenu);
    expect(viewModel.initialDistanceValue, 30);
    expect(viewModel.shouldDisplayDistanceFiltre, true);
    expect(viewModel.initialDomainValue, Domaine.values[2]);
    expect(viewModel.initialStartDateValue, DateTime(2023));
  });

  test("create should not display filter if lat is missing", () {
    // Given
    final state = givenState().successRechercheServiceCiviqueStateWithRequest(
      criteres: ServiceCiviqueCriteresRecherche(location: mockCommuneLocation(lon: 12)),
      filtres: ServiceCiviqueFiltresRecherche(
        distance: 30,
        domain: Domaine.fromTag("solidarite-insertion"),
        startDate: DateTime(2023),
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, false);
  });

  test("create should not display filter if lon is missing", () {
    // Given
    final state = givenState().successRechercheServiceCiviqueStateWithRequest(
      criteres: ServiceCiviqueCriteresRecherche(location: mockCommuneLocation(lat: 12)),
      filtres: ServiceCiviqueFiltresRecherche(
        distance: 30,
        domain: Domaine.fromTag("solidarite-insertion"),
        startDate: DateTime(2023),
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, false);
  });
}
