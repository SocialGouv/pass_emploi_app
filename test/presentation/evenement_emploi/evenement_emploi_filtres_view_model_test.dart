import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_type.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_filtres_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("create when search state is success should display success", () {
    // Given
    final store = givenState().successRechercheEvenementEmploiState(results: [mockEvenementEmploi()]).store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.contenu);
  });

  test("create when search state is loading should display loading", () {
    // Given
    final store = givenState().updateLoadingRechercheEvenementEmploiState().store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.chargement);
  });

  test("create when search state is failure should display failure", () {
    // Given
    final store = givenState().failureRechercheEvenementEmploiState().store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.erreur);
  });

  test(
      "create when search state is success but empty should display content (empty content is directly handled by result page)",
      () {
    // Given
        final store = givenState().successRechercheEvenementEmploiState(results: []).store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.contenu);
  });

  test("create when state has no filtre set should not pre-check any filtre", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(filtres: EvenementEmploiFiltresRecherche.noFiltre())
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.modalitesFiltres, _modalitesWithCheck(enPhysiqueChecked: false, aDistanceChecked: false));
    expect(viewModel.initialTypeValue, isNull);
    expect(viewModel.initialDateDebut, isNull);
    expect(viewModel.initialDateFin, isNull);
  });

  test("create when state has type filtre set should pre-check type", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(
          filtres: EvenementEmploiFiltresRecherche.withFiltres(type: EvenementEmploiType.reunionInformation),
        )
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialTypeValue, EvenementEmploiType.reunionInformation);
  });

  test("create when state has modalité filtre set should pre-check type", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(
          filtres: EvenementEmploiFiltresRecherche.withFiltres(modalites: [EvenementEmploiModalite.enPhysique]),
        )
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.modalitesFiltres, _modalitesWithCheck(enPhysiqueChecked: true, aDistanceChecked: false));
  });

  test("create when state has dates set should pre-check dates", () {
    // Given
    final store = givenState()
        .successRechercheEvenementEmploiStateWithRequest(
          filtres: EvenementEmploiFiltresRecherche.withFiltres(
            dateDebut: DateTime(2030, 1, 1),
            dateFin: DateTime(2030, 1, 2),
          ),
        )
        .store();

    // When
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDateDebut, DateTime(2030, 1, 1));
    expect(viewModel.initialDateFin, DateTime(2030, 1, 2));
  });

  test('updateFiltres should map parameters into actions', () {
    // Given
    final store = StoreSpy();
    final viewModel = EvenementEmploiFiltresViewModel.create(store);

    // When
    viewModel.updateFiltres(
      EvenementEmploiType.conference,
      [CheckboxValueViewModel(label: '', value: EvenementEmploiModalite.enPhysique, isInitiallyChecked: false)],
      DateTime(2030, 1, 1),
      DateTime(2030, 1, 2),
    );

    // Then
    final action = store.dispatchedAction as RechercheUpdateFiltresAction<EvenementEmploiFiltresRecherche>;
    expect(action.filtres.type, EvenementEmploiType.conference);
    expect(action.filtres.modalites, [EvenementEmploiModalite.enPhysique]);
    expect(action.filtres.dateDebut, DateTime(2030, 1, 1));
    expect(action.filtres.dateFin, DateTime(2030, 1, 2));
  });
}

List<CheckboxValueViewModel<EvenementEmploiModalite>> _modalitesWithCheck({
  required bool enPhysiqueChecked,
  required bool aDistanceChecked,
}) {
  return [
    CheckboxValueViewModel(
      label: 'En présentiel',
      value: EvenementEmploiModalite.enPhysique,
      isInitiallyChecked: enPhysiqueChecked,
    ),
    CheckboxValueViewModel(
      label: 'À distance',
      value: EvenementEmploiModalite.aDistance,
      isInitiallyChecked: aDistanceChecked,
    ),
  ];
}
