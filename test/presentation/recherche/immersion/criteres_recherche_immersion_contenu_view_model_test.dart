import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_state.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/immersion/criteres_recherche_immersion_contenu_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group('on create', () {
    test('should display last searched location when initialised', () {
      // Given
      final store = givenState()
          .copyWith(localisationPersistState: LocalisationPersistSuccessState(mockCommuneLocation()))
          .store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.initialLocation, mockCommuneLocation());
    });

    test('should not display last searched department when initialised', () {
      // Given
      final store =
          givenState().copyWith(localisationPersistState: LocalisationPersistSuccessState(mockLocationParis())).store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.initialLocation, null);
    });

    test('should display last searched location when null', () {
      // Given
      final store = givenState().copyWith(localisationPersistState: LocalisationPersistSuccessState(null)).store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.initialLocation, null);
    });

    test('should not display last searched location when not initialised', () {
      // Given
      final store = givenState().copyWith(localisationPersistState: LocalisationPersistNotInitializedState()).store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.initialLocation, null);
    });
  });
  group('displayState', () {
    test('when recherche status is nouvelle recherche should display CONTENT', () {
      // Given
      final store = givenState().initialRechercheImmersionState().store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('when recherche status is initial loading should display LOADING', () {
      // Given
      final store = givenState().initialLoadingRechercheImmersionState().store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when recherche status is failure should display FAILURE', () {
      // Given
      final store = givenState().failureRechercheImmersionState().store();

      // When
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });

  group('onSearchingRequest', () {
    test('on initial request should dispatch proper action without filtres', () {
      // Given
      final store = StoreSpy();
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // When
      viewModel.onSearchingRequest(mockMetier(), mockLocation());

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(
        dispatchedAction,
        isA<RechercheRequestAction<ImmersionCriteresRecherche, ImmersionFiltresRecherche>>(),
      );
      expect(
        (dispatchedAction as RechercheRequestAction<ImmersionCriteresRecherche, ImmersionFiltresRecherche>).request,
        RechercheRequest(
          ImmersionCriteresRecherche(metier: mockMetier(), location: mockLocation()),
          ImmersionFiltresRecherche.noFiltre(),
          1,
        ),
      );
    });

    test('on updated request should dispatch proper action with previous filtres', () {
      // Given
      final previousFiltres = ImmersionFiltresRecherche.distance(50);
      final store = givenState().successRechercheImmersionStateWithRequest(filtres: previousFiltres).spyStore();
      final viewModel = CriteresRechercheImmersionContenuViewModel.create(store);

      // When
      viewModel.onSearchingRequest(mockMetier(), mockLocation());

      // Then
      final dispatchedAction = store.dispatchedAction;
      expect(
        dispatchedAction,
        isA<RechercheRequestAction<ImmersionCriteresRecherche, ImmersionFiltresRecherche>>(),
      );
      expect(
        (dispatchedAction as RechercheRequestAction<ImmersionCriteresRecherche, ImmersionFiltresRecherche>).request,
        RechercheRequest(
          ImmersionCriteresRecherche(metier: mockMetier(), location: mockLocation()),
          ImmersionFiltresRecherche.distance(50),
          1,
        ),
      );
    });
  });
}
