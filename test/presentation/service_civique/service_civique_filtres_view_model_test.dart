import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';

void main() {
  test("create when state is loading should set display loading", () {
    // Given
    final ServiceCiviqueSearchResultState resultState = ServiceCiviqueSearchResultLoadingState();
    final state = AppState.initialState().copyWith(
      serviceCiviqueSearchResultState: resultState,
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when state is failure should set display failure", () {
    // Given
    final ServiceCiviqueSearchResultState resultState = ServiceCiviqueSearchResultErrorState(
      SearchServiceCiviqueRequest(
          page: 1, endDate: null, startDate: null, domain: null, location: mockLocation(), distance: null),
      [],
    );
    final state = AppState.initialState().copyWith(
      serviceCiviqueSearchResultState: resultState,
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test("create when state is result should set display to result with default distance, domain and date", () {
    // Given
    final ServiceCiviqueSearchResultState resultState = ServiceCiviqueSearchResultDataState(
      lastRequest: SearchServiceCiviqueRequest(
        page: 1,
        endDate: null,
        startDate: null,
        domain: null,
        location: mockLocation(),
        distance: null,
      ),
      isMoreDataAvailable: false,
      offres: [
        mockServiceCivique(),
      ],
    );
    final state = AppState.initialState().copyWith(
      serviceCiviqueSearchResultState: resultState,
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.initialDistanceValue, 10);
    expect(viewModel.initialDomainValue, Domaine.all);
    expect(viewModel.initialStartDateValue, null);
  });

  test("create when state is result should set display to result with custom distance, domain and date", () {
    // Given
    final ServiceCiviqueSearchResultState resultState = ServiceCiviqueSearchResultDataState(
      lastRequest: SearchServiceCiviqueRequest(
        page: 1,
        endDate: null,
        startDate: "2022-04-11T12:07:60.000z",
        domain: "solidarite-insertion",
        location: mockCommuneLocation(lat: 12, lon: 12),
        distance: 30,
      ),
      isMoreDataAvailable: false,
      offres: [
        mockServiceCivique(),
      ],
    );
    final state = AppState.initialState().copyWith(
      serviceCiviqueSearchResultState: resultState,
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.initialDistanceValue, 30);
    expect(viewModel.shouldDisplayDistanceFiltre, true);
    expect(viewModel.initialDomainValue, Domaine.values[2]);
    expect(viewModel.initialStartDateValue, "2022-04-11T12:07:60.000z".toDateTimeUtcOnLocalTimeZone());
  });

  test("create should not display filter if lat is missing", () {
    // Given
    final ServiceCiviqueSearchResultState resultState = ServiceCiviqueSearchResultDataState(
      lastRequest: SearchServiceCiviqueRequest(
        page: 1,
        endDate: null,
        startDate: "2022-04-11T12:07:60.000z",
        domain: "solidarite-insertion",
        location: mockCommuneLocation(lon: 12),
        distance: 30,
      ),
      isMoreDataAvailable: false,
      offres: [
        mockServiceCivique(),
      ],
    );
    final state = AppState.initialState().copyWith(
      serviceCiviqueSearchResultState: resultState,
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, false);
  });

  test("create should not display filter if lon is missing", () {
    // Given
    final ServiceCiviqueSearchResultState resultState = ServiceCiviqueSearchResultDataState(
      lastRequest: SearchServiceCiviqueRequest(
        page: 1,
        endDate: null,
        startDate: "2022-04-11T12:07:60.000z",
        domain: "solidarite-insertion",
        location: mockCommuneLocation(lat: 12),
        distance: 30,
      ),
      isMoreDataAvailable: false,
      offres: [
        mockServiceCivique(),
      ],
    );
    final state = AppState.initialState().copyWith(
      serviceCiviqueSearchResultState: resultState,
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueFiltresViewModel.create(store);

    // Then
    expect(viewModel.shouldDisplayDistanceFiltre, false);
  });
}
