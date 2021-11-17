import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/department.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

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
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchDisplayState.SHOW_LOADER);
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
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchDisplayState.SHOW_ERROR);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("create when state is success but empty should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success([], 1),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiSearchDisplayState.SHOW_EMPTY_ERROR);
    expect(viewModel.errorMessage, "Aucune offre ne correspond à votre recherche");
  });

  group("_filterDepartments should return ...", () {
   late OffreEmploiSearchViewModel viewModel;

    setUp(() {
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState(),
      );
      viewModel = OffreEmploiSearchViewModel.create(store);
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
