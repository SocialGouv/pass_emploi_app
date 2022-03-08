import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

main() {
  test("create when id is in favori list should set isFavori to true", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.idsLoaded({"offreId"}),
      ),
    );

    // When
    final viewModel = FavoriHeartViewModel.create("offreId", store, store.state.immersionFavorisState);
    // Then
    expect(viewModel.isFavori, true);
  });

  test("create when id is not in favori list should set isFavori to false", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.idsLoaded({"notOffreId"}),
      ),
    );

    // When
    final viewModel = FavoriHeartViewModel.create("offreId", store, store.state.immersionFavorisState);

    // Then
    expect(viewModel.isFavori, false);
  });

  test("create when id is in favori and an error occurred should set withError to true", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.idsLoaded({"offreId"}),
        favorisUpdateState: FavorisUpdateState({"offreId": FavorisUpdateStatus.ERROR}),
      ),
    );
    // When
    final viewModel = FavoriHeartViewModel.create("offreId", store, store.state.immersionFavorisState);

    // Then
    expect(viewModel.withError, true);
    expect(viewModel.isFavori, true);
  });

  test("create when id is not in favori and an error occurred should set withError to true", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionFavorisState: FavoriListState<Immersion>.idsLoaded({"toto"}),
        favorisUpdateState: FavorisUpdateState({"offreId": FavorisUpdateStatus.ERROR}),
      ),
    );
    // When
    final viewModel = FavoriHeartViewModel.create("offreId", store, store.state.immersionFavorisState);

    // Then
    expect(viewModel.withError, true);
    expect(viewModel.isFavori, false);
  });

  test("create when id status is loading should set withLoading to true", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        favorisUpdateState: FavorisUpdateState({"offreId": FavorisUpdateStatus.LOADING}),
      ),
    );
    // When
    final viewModel = FavoriHeartViewModel.create("offreId", store, store.state.immersionFavorisState);

    // Then
    expect(viewModel.withLoading, true);
  });
}
