import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/remote_campagne_accueil/remote_campagne_accueil_actions.dart';
import 'package:pass_emploi_app/features/remote_campagne_accueil/remote_campagne_accueil_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('RemoteCampagneAccueil', () {
    final sut = StoreSut();
    final repository = MockRemoteCampagneAccueilRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => AccueilRequestAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.getCampagnes()).thenAnswer((_) async => [mockRemoteCampagneAccueil()]);

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.remoteCampagneAccueilRepository = repository});

        sut.thenExpectAtSomePoint(_shouldSucceed());
      });
    });

    group('when deleting', () {
      sut.whenDispatchingAction(() => RemoteCampagneAccueilDismissAction("1"));

      test('should load then succeed when request succeeds', () {
        when(() => repository.dismissCampagne("1")).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .copyWith(
                remoteCampagneAccueilState: RemoteCampagneAccueilState(campagnes: [mockRemoteCampagneAccueil(id: "1")]))
            .store((f) => {f.remoteCampagneAccueilRepository = repository});

        sut.thenExpectAtSomePoint(StateIs<RemoteCampagneAccueilState>(
          (state) => state.remoteCampagneAccueilState,
          (state) {
            expect(state.campagnes, []);
          },
        ));
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<RemoteCampagneAccueilState>(
    (state) => state.remoteCampagneAccueilState,
    (state) {
      expect(state.campagnes, [mockRemoteCampagneAccueil()]);
    },
  );
}
