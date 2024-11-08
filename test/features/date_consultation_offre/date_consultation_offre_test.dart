import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
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

    group("when bootstraping", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should load offres dates', () {
        when(() => repository.get()).thenAnswer((_) async => {"offreId": DateTime(2024, 1, 1)});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.dateConsultationOffreRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });

    group("when writing date", () {
      sut.whenDispatchingAction(() => DateConsultationWriteOffreAction("offreId"));

      test('should write date', () {
        when(() => repository.set("offreId", any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.dateConsultationOffreRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<DateConsultationOffreState>(
    (state) => state.dateConsultationOffreState,
    (state) {
      expect(state.offreIdToDateConsultation, {"offreId": isA<DateTime>()});
    },
  );
}
