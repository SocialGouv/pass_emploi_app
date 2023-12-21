import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/favori_list_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when state is loading should display loading', () {
      // Given
      final store = givenState().favoriListLoadingState().store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test('when state is failure should display failure', () {
      // Given
      final store = givenState().favoriListFailureState().store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });

    test('when state is successful with result should display content', () {
      // Given
      final store = givenState().favoriListSuccessState([mockFavori()]).store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test('when state is successful without result should display empty', () {
      // Given
      final store = givenState().favoriListSuccessState([]).store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.vide);
    });
  });

  test('favoris should return favoris from state', () {
    // Given
    final favoris = [mockFavori()];
    final store = givenState().favoriListSuccessState(favoris).store();

    // When
    final viewModel = FavoriListViewModel.create(store);

    // Then
    expect(viewModel.favoris, favoris);
  });

  test('onRetry should dispatch proper action', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = FavoriListViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<FavoriListRequestAction>());
  });

  group('Favoris filtered', () {
    final favoris = [
      mockFavori('offre-emploi', OffreType.emploi),
      mockFavori('alternance', OffreType.alternance),
      mockFavori('immersion', OffreType.immersion),
      mockFavori('service-civique', OffreType.serviceCivique),
    ];

    test('getOffresEmploi should return favoris of type Offre Emploi', () {
      // Given
      final store = givenState().favoriListSuccessState(favoris).store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.getOffresEmploi(), [mockFavori('offre-emploi', OffreType.emploi)]);
    });

    test('getOffresAlternance should return favoris of type Alternance', () {
      // Given
      final store = givenState().favoriListSuccessState(favoris).store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.getOffresAlternance(), [mockFavori('alternance', OffreType.alternance)]);
    });

    test('getOffresImmersion should return favoris of type Immersion', () {
      // Given
      final store = givenState().favoriListSuccessState(favoris).store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.getOffresImmersion(), [mockFavori('immersion', OffreType.immersion)]);
    });

    test('getOffresServiceCivique should return favoris of type Service Civique ', () {
      // Given
      final store = givenState().favoriListSuccessState(favoris).store();

      // When
      final viewModel = FavoriListViewModel.create(store);

      // Then
      expect(viewModel.getOffresServiceCivique(), [mockFavori('service-civique', OffreType.serviceCivique)]);
    });
  });
}
