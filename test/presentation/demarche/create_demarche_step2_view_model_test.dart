import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step2_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('display state', () {
    group('when source is from recherche', () {
      test('create when state is not initialized should display loading', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .copyWith(searchDemarcheState: SearchDemarcheNotInitializedState()) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource());

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('create when state is loading should display loading', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .copyWith(searchDemarcheState: SearchDemarcheLoadingState()) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource());

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('create when state is failure should display failure', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .copyWith(searchDemarcheState: SearchDemarcheFailureState()) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource());

        // Then
        expect(viewModel.displayState, DisplayState.FAILURE);
      });

      test('create when state is success should display content', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .searchDemarchesSuccess([]) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource());

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });

    group('when source is from thematique', () {
      test('create when state is not initialized should display loading', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .copyWith(thematiquesDemarcheState: ThematiqueDemarcheNotInitializedState()) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, ThematiqueDemarcheSource("any"));

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('create when state is loading should display loading', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .copyWith(thematiquesDemarcheState: ThematiqueDemarcheLoadingState()) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, ThematiqueDemarcheSource("any"));

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('create when state is failure should display failure', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .copyWith(thematiquesDemarcheState: ThematiqueDemarcheFailureState()) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, ThematiqueDemarcheSource("any"));

        // Then
        expect(viewModel.displayState, DisplayState.FAILURE);
      });

      test('create when state is success should display content', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .withThematiqueDemarcheSuccessState(demarches: []) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, ThematiqueDemarcheSource("any"));

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });

    group('when source is from top demarches', () {
      test('create when state is not initialized should display loading', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .copyWith(topDemarcheState: TopDemarcheNotInitializedState()) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, TopDemarcheSource());

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test('create when state is success should display loading', () {
        // Given
        final store = givenState() //
            .loggedIn() //
            .withTopDemarcheSuccessState(demarches: []) //
            .store();

        // When
        final viewModel = CreateDemarcheStep2ViewModel.create(store, TopDemarcheSource());

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });
  });

  group('onRetry', () {
    test('when source is RechercheDemarcheSource should retry search', () {
      // Given
      final store = StoreSpy();
      final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource(), query: "query");

      // When
      viewModel.onRetry();

      // Then
      expect(store.dispatchedAction, isA<SearchDemarcheRequestAction>());
      expect((store.dispatchedAction as SearchDemarcheRequestAction).query, 'query');
    });

    test('when source is ThematiqueDemarcheSource should not retry search', () {
      // Given
      final store = StoreSpy();
      final viewModel = CreateDemarcheStep2ViewModel.create(store, ThematiqueDemarcheSource("P03"));

      // When
      viewModel.onRetry();

      // Then
      expect(store.dispatchedAction, isNull);
    });
  });
  group('when source is recherche', () {
    test('create when state is successful without result should display empty item and button', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .searchDemarchesSuccess([]) //
          .store();

      // When
      final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource());

      // Then
      expect(viewModel.items, [
        CreateDemarcheStep2EmptyItem(),
        CreateDemarcheStep2ButtonItem(),
      ]);
    });

    test('create when state is successful with result should display specific title, items and button', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .searchDemarchesSuccess([mockDemarcheDuReferentiel('1'), mockDemarcheDuReferentiel('2')]) //
          .store();

      // When
      final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource());

      // Then
      expect(viewModel.items.length, 4);

      expect(viewModel.items[0], isA<CreateDemarcheStep2TitleItem>());
      expect(
        (viewModel.items[0] as CreateDemarcheStep2TitleItem).title,
        'Sélectionnez une démarche ou créez une démarche personnalisée',
      );

      expect(viewModel.items[1], isA<CreateDemarcheStep2DemarcheFoundItem>());
      expect((viewModel.items[1] as CreateDemarcheStep2DemarcheFoundItem).idDemarche, '1');

      expect(viewModel.items[2], isA<CreateDemarcheStep2DemarcheFoundItem>());
      expect((viewModel.items[2] as CreateDemarcheStep2DemarcheFoundItem).idDemarche, '2');

      expect(viewModel.items[3], isA<CreateDemarcheStep2ButtonItem>());
    });
  });

  group('when source is thematique', () {
    test('should display demarches associated with given thematique', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .withThematiqueDemarcheSuccessState() //
          .store();

      // When
      final viewModel = CreateDemarcheStep2ViewModel.create(store, ThematiqueDemarcheSource("P03"));

      // Then
      expect(viewModel.items.length, 3);
      expect(viewModel.items[0], isA<CreateDemarcheStep2TitleItem>());
      expect(
        (viewModel.items[0] as CreateDemarcheStep2TitleItem).title,
        'Sélectionnez une démarche ou créez une démarche personnalisée',
      );

      expect(viewModel.items[1], isA<CreateDemarcheStep2DemarcheFoundItem>());
      expect((viewModel.items[1] as CreateDemarcheStep2DemarcheFoundItem).idDemarche, '1');

      expect(viewModel.items[2], isA<CreateDemarcheStep2ButtonItem>());
    });
  });
}
