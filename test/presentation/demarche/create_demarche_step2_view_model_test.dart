import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step2_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('when source is recherche', () {
    test('create when state is successful without result should only display specific title and button', () {
      // Given
      final store = givenState() //
          .loggedInUser() //
          .searchDemarchesSuccess([]) //
          .store();

      // When
      final viewModel = CreateDemarcheStep2ViewModel.create(store, RechercheDemarcheSource());

      // Then
      expect(viewModel.items.length, 2);

      expect(viewModel.items[0], isA<CreateDemarcheStep2TitleItem>());
      expect(
        (viewModel.items[0] as CreateDemarcheStep2TitleItem).title,
        'Aucune démarche pre-renseignée n’a été trouvée',
      );

      expect(viewModel.items[1], isA<CreateDemarcheStep2ButtonItem>());
    });

    test('create when state is successful with result should display specific title, items and button', () {
      // Given
      final store = givenState() //
          .loggedInUser() //
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
          .loggedInUser() //
          .withThematiquesDemarcheSuccessState() //
          .store();

      // When
      final viewModel = CreateDemarcheStep2ViewModel.create(store, ThematiquesDemarcheSource("P03"));

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
