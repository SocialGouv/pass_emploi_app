import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/campagne/result/campagne_result_actions.dart';
import 'package:pass_emploi_app/features/campagne/result/campagne_result_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  group('Campagne retrieval', () {
    test('On Milo user, campagne should be fetched and displayed if any', () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final repository = PageActionRepositorySuccessStub();
      repository.withCampagne(campagne('id-campagne'));
      testStoreFactory.pageActionRepository = repository;
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInMiloState());
      final successAppState = store.onChange.firstWhere((e) => e.campagneState.campagne != null);

      // When
      await store.dispatch(UserActionListRequestAction());

      // Then
      final appState = await successAppState;
      expect(appState.campagneState.campagne!.id, 'id-campagne');
    });

    test('On Pôle Emploi user, campagne should be fetched and displayed if any', () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final repository = PageActionPERepositorySuccessStub();
      repository.withCampagne(campagne('id-campagne'));
      testStoreFactory.pageActionPERepository = repository;
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());
      final successAppState = store.onChange.firstWhere((e) => e.campagneState.campagne != null);

      // When
      await store.dispatch(UserActionPEListRequestAction());

      // Then
      final appState = await successAppState;
      expect(appState.campagneState.campagne!.id, 'id-campagne');
    });
  });

  group('Campagne results', () {
    final testStoreFactory = TestStoreFactory();
    late CampagneRepositoryStub repository;
    late Store<AppState> store;

    setUp(() {
      repository = CampagneRepositoryStub();
      testStoreFactory.campagneRepository = repository;
      store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(campagneState: CampagneState(mockCampagne())),
      );
    });

    test('On first answer, post first answer to repository', () async {
      // When
      await store.dispatch(CampagneResultAction(1, 2, 'pourquoi-question-1'));

      // Then
      expect(
        repository.hasBeenCalledWith(
          'id',
          'id-campagne',
          [CampagneQuestionAnswer(1, 2, 'pourquoi-question-1')],
        ),
        isTrue,
      );
    });

    test('On second answer, post first and second answer to repository', () async {
      // Given
      await store.dispatch(CampagneResultAction(1, 2, 'pourquoi-question-1'));

      // When
      await store.dispatch(CampagneResultAction(2, 3, null));

      // Then
      expect(
        repository.hasBeenCalledWith(
          'id',
          'id-campagne',
          [
            CampagneQuestionAnswer(1, 2, 'pourquoi-question-1'),
            CampagneQuestionAnswer(2, 3, null),
          ],
        ),
        isTrue,
      );
    });

    test('On updated answer, do not post back previous answer to repository', () async {
      // Given
      await store.dispatch(CampagneResultAction(1, 2, 'pourquoi-question-1'));

      // When
      await store.dispatch(CampagneResultAction(1, 2, 'nouveau-pourquoi-question-1'));

      // Then
      expect(
        repository.hasBeenCalledWith(
          'id',
          'id-campagne',
          [CampagneQuestionAnswer(1, 2, 'nouveau-pourquoi-question-1')],
        ),
        isTrue,
      );
    });
  });

  group('Campagne reset', () {
    test('should clear campagne and results', () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final store = testStoreFactory.initializeReduxStore(
        initialState: loggedInState().copyWith(
          campagneState: CampagneState(campagne()),
          campagneResultState: CampagneResultState([CampagneQuestionAnswer(1, 2, null)]),
        ),
      );

      // When
      await store.dispatch(CampagneResetAction());

      // Then
      final state = store.state;
      expect(state.campagneState.campagne, isNull);
      expect(state.campagneResultState.answers, isEmpty);
    });
  });
}

class CampagneRepositoryStub extends CampagneRepository {
  String? _userId;
  String? _campagneId;
  List<CampagneQuestionAnswer>? _updatedAnswers;

  CampagneRepositoryStub() : super("", DummyHttpClient());

  @override
  Future<void> postAnswers(String userId, String campagneId, List<CampagneQuestionAnswer> updatedAnswers) async {
    _userId = userId;
    _campagneId = campagneId;
    _updatedAnswers = updatedAnswers;
  }

  bool hasBeenCalledWith(String userId, String campagneId, List<CampagneQuestionAnswer> updatedAnswers) {
    return _userId == userId && _campagneId == campagneId && listEquals(_updatedAnswers, updatedAnswers);
  }
}

Campagne mockCampagne() {
  return Campagne(
    id: 'id-campagne',
    titre: 'titre-campagne',
    description: 'description-campagne',
    questions: [
      Question(
        id: 1,
        libelle: 'question-1',
        options: [
          Option(id: 1, libelle: 'option-1'),
          Option(id: 2, libelle: 'option-2'),
        ],
      ),
      Question(
        id: 2,
        libelle: 'question-2',
        options: [
          Option(id: 1, libelle: 'option-1'),
          Option(id: 2, libelle: 'option-2'),
          Option(id: 3, libelle: 'option-3'),
        ],
      )
    ],
  );
}
