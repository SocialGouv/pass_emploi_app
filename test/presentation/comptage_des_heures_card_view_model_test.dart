import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/comptage_des_heures_card_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('display state', () {
    test('dshould be loading when comptage des heures is not initialized', () {
      // Given
      final store = givenState().loggedInMiloUser().withComptageDesHeuresNotInitialized().store();

      // When
      final viewModel = ComptageDesHeuresCardViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should be failure when comptage des heures is failure', () {
      // Given
      final store = givenState().loggedInMiloUser().withComptageDesHeuresFailure().store();

      // When
      final viewModel = ComptageDesHeuresCardViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('should be content when comptage des heures is success', () {
      // Given
      final store = givenState().loggedInMiloUser().withComptageDesHeuresSuccess().store();

      // When
      final viewModel = ComptageDesHeuresCardViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });
  });

  test('0 to 5 hours should be encouraging', () {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withComptageDesHeuresSuccess(
          comptageDesHeures: mockComptageDesHeures(
            nbHeuresValidees: 4,
            nbHeuresDeclarees: 4,
          ),
        )
        .store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.title, "C’est le moment de compléter vos actions\u{00A0}!\u{00A0}🚀");
    expect(viewModel.pourcentageHeuresValidees, 0.26666666666666666);
    expect(viewModel.pourcentageHeuresDeclarees, 0.26666666666666666);
    expect(viewModel.heuresDeclarees, "4");
    expect(viewModel.heuresValidees, "4");
    expect(viewModel.emoji, "😉");
  });

  test('5 to 10 hours should be good but not great', () {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withComptageDesHeuresSuccess(
          comptageDesHeures: mockComptageDesHeures(
            nbHeuresValidees: 9,
            nbHeuresDeclarees: 9,
          ),
        )
        .store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.title, "Bon début, continuez comme ça\u{00A0}!\u{00A0}💪");
    expect(viewModel.pourcentageHeuresValidees, 0.6);
    expect(viewModel.pourcentageHeuresDeclarees, 0.6);
    expect(viewModel.heuresDeclarees, "9");
    expect(viewModel.heuresValidees, "9");
    expect(viewModel.emoji, "🙂");
  });

  test('10 to 15 hours should be great', () {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withComptageDesHeuresSuccess(
          comptageDesHeures: mockComptageDesHeures(
            nbHeuresValidees: 14,
            nbHeuresDeclarees: 14,
          ),
        )
        .store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.title, "Vous vous rapprochez de votre objectif : encore un petit effort\u{00A0}!\u{00A0}🌟");
    expect(viewModel.pourcentageHeuresValidees, 0.9333333333333333);
    expect(viewModel.pourcentageHeuresDeclarees, 0.9333333333333333);
    expect(viewModel.heuresDeclarees, "14");
    expect(viewModel.heuresValidees, "14");
    expect(viewModel.emoji, "😛");
  });

  test('15 hours should be top', () {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withComptageDesHeuresSuccess(
          comptageDesHeures: mockComptageDesHeures(
            nbHeuresValidees: 15,
            nbHeuresDeclarees: 15,
          ),
        )
        .store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.title, "🎉 Félicitations pour vos 15h d’activités validées\u{00A0}!");
    expect(viewModel.pourcentageHeuresValidees, 1);
    expect(viewModel.pourcentageHeuresDeclarees, 1);
    expect(viewModel.heuresDeclarees, "15");
    expect(viewModel.heuresValidees, "15");
    expect(viewModel.emoji, "😍");
  });

  test('15+ hours should be amazing', () {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withComptageDesHeuresSuccess(
          comptageDesHeures: mockComptageDesHeures(
            nbHeuresValidees: 16,
            nbHeuresDeclarees: 16,
          ),
        )
        .store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.title, "Objectif dépassé ! Bravo\u{00A0}👏");
    expect(viewModel.pourcentageHeuresValidees, 1);
    expect(viewModel.pourcentageHeuresDeclarees, 1);
    expect(viewModel.heuresDeclarees, "16");
    expect(viewModel.heuresValidees, "16");
    expect(viewModel.emoji, "🤩");
  });

  test('heures en cours de calcul should be null when comptage des heures is not success', () {
    // Given
    final store = givenState().loggedInMiloUser().withComptageDesHeuresNotInitialized().store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.heuresEnCoursDeCalcul, null);
  });

  test('heures en cours de calcul should be 1 when comptage des heures is success and heures en cours de calcul is 1',
      () {
    // Given
    final store = givenState().loggedInMiloUser().withComptageDesHeuresSuccess(heuresEnCoursDeCalcul: 1).store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.heuresEnCoursDeCalcul,
        "1 activité en cours de calcul.\nProchaine actualisation dans moins d’une heure");
  });

  test('heures en cours de calcul should be 2 when comptage des heures is success and heures en cours de calcul is 2',
      () {
    // Given
    final store = givenState().loggedInMiloUser().withComptageDesHeuresSuccess(heuresEnCoursDeCalcul: 2).store();

    // When
    final viewModel = ComptageDesHeuresCardViewModel.create(store);

    // Then
    expect(viewModel.heuresEnCoursDeCalcul,
        "2 activités en cours de calcul.\nProchaine actualisation dans moins d’une heure");
  });
}
