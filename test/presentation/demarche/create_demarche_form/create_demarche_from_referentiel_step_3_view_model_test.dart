import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_from_referentiel_step_3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';

import '../../../doubles/fixtures.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test('create when demarche has no comment', () {
    // Given
    final demarche = mockDemarcheDuReferentiel('id', []);
    final store = givenState() //
        .loggedIn() //
        .withThematiqueDemarcheSuccessState(demarches: [demarche]) //
        .store();

    // When
    final viewModel = CreateDemarche2FromReferentielStep3ViewModel.create(store, 'id', "P03");

    // Then
    expect(viewModel.comments, isEmpty);
    expect(viewModel.isCommentMandatory, false);
  });

  test('create when demarche has comment', () {
    // Given
    final demarche = mockDemarcheDuReferentiel('id', [Comment(label: 'label1', code: 'code1')]);
    final store = givenState() //
        .loggedIn() //
        .withThematiqueDemarcheSuccessState(demarches: [demarche]) //
        .store();

    // When
    final viewModel = CreateDemarche2FromReferentielStep3ViewModel.create(store, 'id', "P03");

    // Then
    expect(viewModel.comments, [CommentTextItem(label: 'label1', code: 'code1')]);
    expect(viewModel.isCommentMandatory, true);
  });
}
