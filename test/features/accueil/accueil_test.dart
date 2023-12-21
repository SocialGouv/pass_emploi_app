import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/traiter/traiter_suggestion_recherche_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/accueil_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Accueil', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.whenDispatchingAction(() => AccueilRequestAction());

      test('should load then succeed when request succeed for milo', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedMilo()]);
      });

      test('should load then fail when request fail for milo', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.accueilRepository = AccueilRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should load then succeed when request succeed for PoleEmploi', () {
        sut.givenStore = givenState() //
            .loggedInPoleEmploiUser()
            .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedPoleEmploi()]);
      });

      test('should load then fail when request fail for PoleEmploi', () {
        sut.givenStore = givenState() //
            .loggedInPoleEmploiUser()
            .store((f) => {f.accueilRepository = AccueilRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });

    group("when a user change occurs", () {
      void expectLoadingWhen(dynamic action) {
        sut.whenDispatchingAction(() => action);

        test('should load then succeed when request succeed for milo', () {
          sut.givenStore = givenState() //
              .loggedInUser()
              .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});

          sut.thenExpectChangingStatesThroughOrder([_shouldLoad()]);
        });
      }

      expectLoadingWhen(UserActionCreateSuccessAction("id"));
      expectLoadingWhen(UserActionDeleteSuccessAction("id"));
      expectLoadingWhen(UserActionUpdateSuccessAction(actionId: "id", newStatus: UserActionStatus.DONE));
      expectLoadingWhen(CreateDemarcheSuccessAction("id"));
      expectLoadingWhen(UpdateDemarcheSuccessAction(uneDemarche()));
      expectLoadingWhen(FavoriUpdateSuccessAction("id", FavoriStatus.removed));
      expectLoadingWhen(AlerteCreateSuccessAction(mockOffreEmploiAlerte()));
      expectLoadingWhen(AlerteDeleteSuccessAction("id"));
      expectLoadingWhen(AccepterSuggestionRechercheSuccessAction("id", mockOffreEmploiAlerte()));
      expectLoadingWhen(RefuserSuggestionRechercheSuccessAction("id"));
    });

    group("when pending user actions have been created", () {
      sut.whenDispatchingAction(() => UserActionCreatePendingAction(0));

      group("and request succeeds", () {
        test("should display loading and success", () {
          sut.givenStore = givenState()
              .loggedInUser() //
              .withPendingUserActions(1)
              .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});
          sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedMilo()]);
        });
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<AccueilLoadingState>((state) => state.accueilState);

Matcher _shouldFail() => StateIs<AccueilFailureState>((state) => state.accueilState);

Matcher _shouldSucceedMilo() {
  return StateIs<AccueilSuccessState>(
    (state) => state.accueilState,
    (state) {
      expect(state.accueil, mockAccueilMilo());
    },
  );
}

Matcher _shouldSucceedPoleEmploi() {
  return StateIs<AccueilSuccessState>(
    (state) => state.accueilState,
    (state) {
      expect(state.accueil, mockAccueilPoleEmploi());
    },
  );
}

class AccueilRepositorySuccessStub extends AccueilRepository {
  AccueilRepositorySuccessStub() : super(DioMock());

  @override
  Future<Accueil?> getAccueilMissionLocale(String userId, DateTime maintenant) async {
    return mockAccueilMilo();
  }

  @override
  Future<Accueil?> getAccueilPoleEmploi(String userId, DateTime maintenant) async {
    return mockAccueilPoleEmploi();
  }
}

class AccueilRepositoryErrorStub extends AccueilRepository {
  AccueilRepositoryErrorStub() : super(DioMock());

  @override
  Future<Accueil?> getAccueilMissionLocale(String userId, DateTime maintenant) async {
    return null;
  }

  @override
  Future<Accueil?> getAccueilPoleEmploi(String userId, DateTime maintenant) async {
    return null;
  }
}
