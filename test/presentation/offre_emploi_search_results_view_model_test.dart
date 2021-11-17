import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../models/offre_emploi_test.dart';

main() {
  test("create when state is success should set convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.success(offreEmploiData()),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.items, [
      OffreEmploiItemViewModel(
        "123DXPM",
        "Technicien / Technicienne en froid et climatisation",
        "RH TT INTERIM",
        "MIS",
        "Temps plein",
        "77 - LOGNES",
      ),
      OffreEmploiItemViewModel(
        "123DXPK",
        " #SALONDEMANDELIEU2021: RECEPTIONNISTE TOURNANT (H/F)",
        "STAND CHATEAU DE LA BEGUDE",
        "CDD",
        "Temps partiel",
        "06 - OPIO",
      ),
      OffreEmploiItemViewModel(
        "123DXPG",
        "Technicien / Technicienne terrain Structure          (H/F)",
        "GEOTEC",
        "CDI",
        "Temps plein",
        "78 - PLAISIR",
      ),
      OffreEmploiItemViewModel(
        "123DXPF",
        "Responsable de boutique",
        "GINGER",
        "CDD",
        null,
        "13 - AIX EN PROVENCE",
      ),
      OffreEmploiItemViewModel(
        "123DXLK",
        "Commercial sédentaire en Assurances H/F",
        null,
        "CDI",
        "Temps plein",
        "34 - MONTPELLIER",
      )
    ]);
  });
}
