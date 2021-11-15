import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/department.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../models/offre_emploi_test.dart';

main() {
  test("create when state is loading should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.loading(),
      ),
    );

    // When
    final viewModel = OffreEmploiListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiListDisplayState.SHOW_LOADER);
  });

  test("create when state is failure should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
      ),
    );

    // When
    final viewModel = OffreEmploiListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiListDisplayState.SHOW_ERROR);
  });

  test("create when state is success but empty should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success([]),
      ),
    );

    // When
    final viewModel = OffreEmploiListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiListDisplayState.SHOW_EMPTY_ERROR);
  });

  test("create when state is success should set display state properly and convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success(offreEmploiData()),
      ),
    );

    // When
    final viewModel = OffreEmploiListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiListDisplayState.SHOW_CONTENT);
    expect(viewModel.items, [
      OffreEmploiItemViewModel(
        "123DXPM",
        "Technicien / Technicienne en froid et climatisation",
        "RH TT INTERIM",
        "MIS",
        "77 - LOGNES",
      ),
      OffreEmploiItemViewModel(
        "123DXPK",
        " #SALONDEMANDELIEU2021: RECEPTIONNISTE TOURNANT (H/F)",
        "STAND CHATEAU DE LA BEGUDE",
        "CDD",
        "06 - OPIO",
      ),
      OffreEmploiItemViewModel(
        "123DXPG",
        "Technicien / Technicienne terrain Structure          (H/F)",
        "GEOTEC",
        "CDI",
        "78 - PLAISIR",
      ),
      OffreEmploiItemViewModel(
        "123DXPF",
        "Responsable de boutique",
        "GINGER",
        "CDD",
        "13 - AIX EN PROVENCE",
      ),
      OffreEmploiItemViewModel(
        "123DXLK",
        "Commercial sédentaire en Assurances H/F",
        null,
        "CDI",
        "34 - MONTPELLIER",
      )
    ]);
  });


  group("_filterDepartments should return ...", () {
   late OffreEmploiListPageViewModel viewModel;

    setUp(() {
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState(),
      );
      viewModel = OffreEmploiListPageViewModel.create(store);
    });

    test("filtered list of departments when user input match to department name", () {
      expect(viewModel.filterDepartments("Paris"), Department.values.where((d) => d.number == "75"));
    });

   test("filtered list of departments when user input has different cases in the department name", () {
     expect(viewModel.filterDepartments("paris"), Department.values.where((d) => d.number == "75"));
     expect(viewModel.filterDepartments("paRis"), Department.values.where((d) => d.number == "75"));
     expect(viewModel.filterDepartments("pariS"), Department.values.where((d) => d.number == "75"));
   });

   test("filtered list of departments when user input not complete", () {
     expect(viewModel.filterDepartments("par"), Department.values.where((d) => d.number == "75"));
     expect(viewModel.filterDepartments("ris"), Department.values.where((d) => d.number == "75"));
   });

   test("empty list when user input is empty", () {
     expect(viewModel.filterDepartments(""), []);
   });

   test("empty list when user input contains only one character", () {
     expect(viewModel.filterDepartments("p"), []);
   });

   test("filtered list of departments when user input contains diacritics in the department name", () {
     expect(viewModel.filterDepartments("Rhône"),  Department.values.where((d) => d.number == "69" || d.number == "13"));
     expect(viewModel.filterDepartments("Rhone"),  Department.values.where((d) => d.number == "69" || d.number == "13"));
   });

   test("filtered list of departments when user input contains spaces in the department name", () {
     expect(viewModel.filterDepartments("Ille et Vilaine"),  Department.values.where((d) => d.number == "35"));
     expect(viewModel.filterDepartments("Val d Oise"),  Department.values.where((d) => d.number == "95"));
     expect(viewModel.filterDepartments("           Val d Oise   "),  Department.values.where((d) => d.number == "95"));

   });

  });
}
