import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/list/alerte_list_state.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/pages/offre_filters_bottom_sheet.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_list_view_model.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_navigation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  final List<Alerte> alertes = [
    ImmersionAlerte(
      id: "id",
      title: "titreImmersion1",
      metier: "metierImmersion1",
      codeRome: "rome",
      location: mockLocation(),
      ville: "ville",
      filtres: ImmersionFiltresRecherche.noFiltre(),
    ),
    ImmersionAlerte(
      id: "id",
      title: "titreImmersion2",
      metier: "metierImmersion2",
      codeRome: "rome",
      location: mockLocation(),
      ville: "ville",
      filtres: ImmersionFiltresRecherche.noFiltre(),
    ),
    OffreEmploiAlerte(
      id: "id",
      title: "titreOffreEmploi1",
      metier: "metierOffreEmploi1",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.noFiltre(),
    ),
    OffreEmploiAlerte(
      title: "titreOffreEmploi2",
      id: "id",
      metier: "metierOffreEmploi2",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: false,
      filters: EmploiFiltresRecherche.noFiltre(),
    ),
    OffreEmploiAlerte(
      id: "id",
      title: "titreAlternance1",
      metier: "metierAlternance1",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: true,
      filters: EmploiFiltresRecherche.noFiltre(),
    ),
    OffreEmploiAlerte(
      id: "id",
      title: "titreAlternance2",
      metier: "metierAlternance2",
      location: mockLocation(),
      keyword: "keywords",
      onlyAlternance: true,
      filters: EmploiFiltresRecherche.noFiltre(),
    ),
    ServiceCiviqueAlerte(
      id: 'id',
      titre: 'titreServiceCivique',
      filtres: ServiceCiviqueFiltresParameters.noFiltres(),
    ),
  ];

  test("create should set loading properly", () {
    // Given
    final store = givenState().copyWith(alerteListState: AlerteListLoadingState()).store();

    // When
    final viewModel = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create should set failure properly", () {
    // Given
    final store = givenState().copyWith(alerteListState: AlerteListFailureState()).store();

    // When
    final viewModel = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  group('getAlertesFiltered', () {
    late AlerteListViewModel viewModel;

    setUp(() {
      final store = givenState().copyWith(alerteListState: AlerteListSuccessState(alertes)).store();
      viewModel = AlerteListViewModel.createFromStore(store);
    });

    test('with filtre OffreFilter.tous', () {
      // When
      final result = viewModel.getAlertesFiltered(OffreFilter.tous);

      // Then
      expect(result, alertes);
    });

    test('with filtre OffreFilter.emploi', () {
      // When
      final result = viewModel.getAlertesFiltered(OffreFilter.emploi);

      // Then
      expect(result, [
        OffreEmploiAlerte(
          id: "id",
          title: "titreOffreEmploi1",
          metier: "metierOffreEmploi1",
          location: mockLocation(),
          keyword: "keywords",
          onlyAlternance: false,
          filters: EmploiFiltresRecherche.noFiltre(),
        ),
        OffreEmploiAlerte(
          id: "id",
          title: "titreOffreEmploi2",
          metier: "metierOffreEmploi2",
          location: mockLocation(),
          keyword: "keywords",
          onlyAlternance: false,
          filters: EmploiFiltresRecherche.noFiltre(),
        ),
      ]);
    });

    test('with filtre OffreFilter.alternance', () {
      // When
      final result = viewModel.getAlertesFiltered(OffreFilter.alternance);

      // Then
      expect(result, [
        OffreEmploiAlerte(
          id: "id",
          title: "titreAlternance1",
          metier: "metierAlternance1",
          location: mockLocation(),
          keyword: "keywords",
          onlyAlternance: true,
          filters: EmploiFiltresRecherche.noFiltre(),
        ),
        OffreEmploiAlerte(
          id: "id",
          title: "titreAlternance2",
          metier: "metierAlternance2",
          location: mockLocation(),
          keyword: "keywords",
          onlyAlternance: true,
          filters: EmploiFiltresRecherche.noFiltre(),
        ),
      ]);
    });

    test('with filtre OffreFilter.serviceCivique', () {
      // When
      final result = viewModel.getAlertesFiltered(OffreFilter.serviceCivique);

      // Then
      expect(result, [
        ServiceCiviqueAlerte(
          id: 'id',
          titre: 'titreServiceCivique',
          filtres: ServiceCiviqueFiltresParameters.noFiltres(),
        ),
      ]);
    });

    test('with filtre OffreFilter.immersion', () {
      // When
      final result = viewModel.getAlertesFiltered(OffreFilter.immersion);

      // Then
      expect(result, [
        ImmersionAlerte(
          id: "id",
          title: "titreImmersion1",
          metier: "metierImmersion1",
          codeRome: "rome",
          location: mockLocation(),
          ville: "ville",
          filtres: ImmersionFiltresRecherche.noFiltre(),
        ),
        ImmersionAlerte(
          id: "id",
          title: "titreImmersion2",
          metier: "metierImmersion2",
          codeRome: "rome",
          location: mockLocation(),
          ville: "ville",
          filtres: ImmersionFiltresRecherche.noFiltre(),
        ),
      ]);
    });
  });

  test("ViewModel with same content should be equals", () {
    // Given
    final store = givenState().copyWith(alerteListState: AlerteListSuccessState(alertes)).store();

    // When
    final viewModel1 = AlerteListViewModel.createFromStore(store);
    final viewModel2 = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel1 == viewModel2, isTrue);
  });

  test("ViewModel with different content should not be equals", () {
    // Given
    final store1 = givenState().copyWith(alerteListState: AlerteListSuccessState(alertes)).store();
    final store2 = givenState().copyWith(alerteListState: AlerteListSuccessState(alertes.sublist(0, 2))).store();

    // When
    final viewModel1 = AlerteListViewModel.createFromStore(store1);
    final viewModel2 = AlerteListViewModel.createFromStore(store2);

    // Then
    expect(viewModel1 == viewModel2, isFalse);
  });

  test(
      "ViewModel MUST create a copy and not just a reference of state's alertes to ensure StoreConnector.distinct properly works",
      () {
    // Given
        final store = givenState().copyWith(alerteListState: AlerteListSuccessState(alertes)).store();

    // When
    final viewModel = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel.alertes, isNotEmpty);
  });

  test("ViewModel should set navigation to offres emploi when search results are ready", () {
    // Given
    final store = givenState() //
        .copyWith(alerteListState: AlerteListSuccessState(alertes))
        .successRechercheEmploiState()
        .store();

    // When
    final viewModel = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, AlerteNavigationState.OFFRE_EMPLOI);
  });

  test("ViewModel should set navigation to offres alternances when search results are ready", () {
    // Given
    final store = givenState()
        .copyWith(alerteListState: AlerteListSuccessState(alertes))
        .successRechercheEmploiStateWithRequest(
          criteres: EmploiCriteresRecherche(
            keyword: "keyword",
            location: null,
            rechercheType: RechercheType.onlyAlternance,
          ),
        )
        .store();

    // When
    final viewModel = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, AlerteNavigationState.OFFRE_ALTERNANCE);
  });

  test("ViewModel should set navigation to offres immersions when search results are ready", () {
    // Given
    final store = givenState()
        .copyWith(alerteListState: AlerteListSuccessState(alertes))
        .successRechercheImmersionState()
        .store();

    // When
    final viewModel = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, AlerteNavigationState.OFFRE_IMMERSION);
  });

  test("ViewModel should set navigation to service civique when search results are ready", () {
    // Given
    final store = givenState()
        .copyWith(alerteListState: AlerteListSuccessState(alertes))
        .successRechercheServiceCiviqueState()
        .store();

    // When
    final viewModel = AlerteListViewModel.createFromStore(store);

    // Then
    expect(viewModel.searchNavigationState, AlerteNavigationState.SERVICE_CIVIQUE);
  });
}
