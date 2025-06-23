import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_actions.dart';
import 'package:pass_emploi_app/features/demarche/create_demarche_batch/create_demarche_batch_state.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';

import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

class MockCreateDemarcheRepository extends Mock implements CreateDemarcheRepository {
  void withCreateAndReturnSuccess() {
    when(() => createDemarche(
          userId: any(named: "userId"),
          codeQuoi: any(named: "codeQuoi"),
          codePourquoi: any(named: "codePourquoi"),
          codeComment: any(named: "codeComment"),
          dateEcheance: any(named: "dateEcheance"),
          estDuplicata: any(named: "estDuplicata"),
        )).thenAnswer((_) async => "demarcheId");
  }

  void withCreateAndReturnFailure() {
    when(() => createDemarche(
          userId: any(named: "userId"),
          codeQuoi: any(named: "codeQuoi"),
          codePourquoi: any(named: "codePourquoi"),
          codeComment: any(named: "codeComment"),
          dateEcheance: any(named: "dateEcheance"),
          estDuplicata: any(named: "estDuplicata"),
        )).thenAnswer((_) async => null);
  }
}

void main() {
  group('CreateDemarcheBatch', () {
    final sut = StoreSut();
    final repository = MockCreateDemarcheRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => CreateDemarcheBatchRequestAction([
            CreateDemarcheRequestAction(
              codeQuoi: "codeQuoi",
              codePourquoi: "codePourquoi",
              codeComment: "codeComment",
              dateEcheance: DateTime.now(),
              estDuplicata: false,
            ),
          ]));

      test('should load then succeed when request succeeds', () {
        repository.withCreateAndReturnSuccess();

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.createDemarcheRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        repository.withCreateAndReturnFailure();

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.createDemarcheRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<CreateDemarcheBatchLoadingState>((state) => state.createDemarcheBatchState);

Matcher _shouldFail() => StateIs<CreateDemarcheBatchFailureState>((state) => state.createDemarcheBatchState);

Matcher _shouldSucceed() => StateIs<CreateDemarcheBatchSuccessState>((state) => state.createDemarcheBatchState);
