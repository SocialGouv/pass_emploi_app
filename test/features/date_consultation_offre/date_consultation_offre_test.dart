import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_consultation_offre_actions.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_consultation_offre_state.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('DateConsultationOffre', () {
    final sut = StoreSut();
    final repository = MockDateConsultationOffreRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => DateConsultationReadOffreRequestAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => true);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.dateConsultationOffreRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.get()).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.dateConsultationOffreRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<DateConsultationOffreLoadingState>((state) => state.dateConsultationOffreState);

Matcher _shouldFail() => StateIs<DateConsultationOffreFailureState>((state) => state.dateConsultationOffreState);

Matcher _shouldSucceed() {
  return StateIs<DateConsultationOffreSuccessState>(
    (state) => state.dateConsultationOffreState,
    (state) {
      expect(state.result, true);
    },
  );
}
