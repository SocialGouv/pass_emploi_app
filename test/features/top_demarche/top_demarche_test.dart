import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_actions.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/top_demarche_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('TopDemarche', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.whenDispatchingAction(() => TopDemarcheRequestAction());

      test('should return a success with top demarches', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.topDemarcheRepository = MockTopDemarcheRepository()..withTopDemarches()});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed()]);
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<TopDemarcheSuccessState>(
    (state) => state.topDemarcheState,
    (state) {
      expect(state.demarches, _topDemarches);
    },
  );
}

class MockTopDemarcheRepository extends Mock implements TopDemarcheRepository {
  void withTopDemarches() {
    when(() => getTopDemarches()).thenReturn(_topDemarches);
  }
}

List<DemarcheDuReferentiel> _topDemarches = [
  mockDemarcheDuReferentiel("1"),
  mockDemarcheDuReferentiel("2"),
  mockDemarcheDuReferentiel("3")
];
