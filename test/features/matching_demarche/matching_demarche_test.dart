import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_actions.dart';
import 'package:pass_emploi_app/features/matching_demarche/matching_demarche_state.dart';
import 'package:pass_emploi_app/repositories/matching_demarche_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  late MockMatchingDemarcheRepository repository;

  setUp(() {
    repository = MockMatchingDemarcheRepository();
    repository.setUpAll();
  });

  group('MatchingDemarche', () {
    final sut = StoreSut();

    final demarche = mockDemarche(id: 'id');

    group("when requesting", () {
      sut.whenDispatchingAction(() => MatchingDemarcheRequestAction(demarcheId: demarche.id));

      group('when action is loaded', () {
        test('should load then succeed when request succeed', () {
          sut.givenStore = givenState() //
              .loggedIn()
              .withDemarches([demarche]).store((f) => {f.matchingDemarcheRepository = repository..withSuccess()});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
        });

        test('should load then succeed with null when request fail', () {
          sut.givenStore = givenState() //
              .loggedIn()
              .withDemarches([demarche]).store((f) => {f.matchingDemarcheRepository = repository..withFailure()});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedWithNull()]);
        });
      });

      group('when action is not loaded', () {
        test('should fail', () {
          sut.givenStore = givenState() //
              .loggedIn()
              .store((f) => {f.matchingDemarcheRepository = repository..withFailure()});

          sut.thenExpectChangingStatesThroughOrder([_shouldFail()]);
        });
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<MatchingDemarcheLoadingState>((state) => state.matchingDemarcheState);

Matcher _shouldFail() => StateIs<MatchingDemarcheFailureState>((state) => state.matchingDemarcheState);

Matcher _shouldSucceedWithNull() {
  return StateIs<MatchingDemarcheSuccessState>(
    (state) => state.matchingDemarcheState,
    (state) {
      expect(state.result, null);
    },
  );
}

Matcher _shouldSucceed() {
  return StateIs<MatchingDemarcheSuccessState>(
    (state) => state.matchingDemarcheState,
    (state) {
      expect(state.result, dummyDemarcheDurReferentiel());
    },
  );
}

class MockMatchingDemarcheRepository extends Mock implements MatchingDemarcheRepository {
  void setUpAll() {
    registerFallbackValue(mockDemarche());
  }

  void withSuccess() {
    when(() => getMatchingDemarcheDuReferentiel(any())).thenAnswer((_) async => dummyDemarcheDurReferentiel());
  }

  void withFailure() {
    when(() => getMatchingDemarcheDuReferentiel(any())).thenAnswer((_) async => null);
  }
}
