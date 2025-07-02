import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_actions.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_state.dart';
import 'package:pass_emploi_app/models/comptage_des_heures.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('ComptageDesHeures', () {
    final sut = StoreSut();
    final repository = MockComptageDesHeuresRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => ComptageDesHeuresRequestAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get(userId: any(named: "userId"))).thenAnswer((_) async => ComptageDesHeures(
              nbHeuresDeclarees: 10,
              nbHeuresValidees: 8,
              dateDerniereMiseAJour: DateTime(2021, 7, 19, 15, 10, 0),
            ));

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.comptageDesHeuresRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fails', () {
        when(() => repository.get(userId: any(named: "userId"))).thenAnswer((_) async => null);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.comptageDesHeuresRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<ComptageDesHeuresLoadingState>((state) => state.comptageDesHeuresState);

Matcher _shouldFail() => StateIs<ComptageDesHeuresFailureState>((state) => state.comptageDesHeuresState);

Matcher _shouldSucceed() {
  return StateIs<ComptageDesHeuresSuccessState>(
    (state) => state.comptageDesHeuresState,
    (state) {
      expect(
          state.comptageDesHeures,
          ComptageDesHeures(
            nbHeuresDeclarees: 10,
            nbHeuresValidees: 8,
            dateDerniereMiseAJour: DateTime(2021, 7, 19, 15, 10, 0),
          ));
    },
  );
}
