import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:redux/redux.dart';

main() {
  test("create when id is in favori list should set isFavori to true", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiFavorisState: OffreEmploiFavorisIdLoadedState(["offreId"]),
      ),
    );

    // When
    final viewModel = FavoriHeartViewModel.create("offreId", store);
    // Then
    expect(viewModel.isFavori, true);
  });

  test("create when id is not in favori list should set isFavori to false", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiFavorisState: OffreEmploiFavorisIdLoadedState(["notOffreId"]),
      ),
    );

    // When
    final viewModel = FavoriHeartViewModel.create("offreId", store);

    // Then
    expect(viewModel.isFavori, false);
  });

  test("create when id is in favori and an error occured should set withError to true", () {});

  test("create when id is not in favori and an error occured should set withError to true", () {});
}
