import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/campagne/campagne_actions.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/campagne_question_answer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/campagne_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/test_setup.dart';
import '../accueil/accueil_test.dart';

void main() {
  group('Campagne retrieval', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.when(() => AccueilRequestAction());

      test('should succeed when request succeed for milo', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldHaveCampagne()]);
      });

      test('should fail when request fail for milo', () {
        sut.givenStore = givenState() //
            .loggedInMiloUser()
            .store((f) => {f.accueilRepository = AccueilRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldNotHaveCampagne()]);
      });

      test('should succeed when request succeed for PoleEmploi', () {
        sut.givenStore = givenState() //
            .loggedInPoleEmploiUser()
            .store((f) => {f.accueilRepository = AccueilRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldHaveCampagne()]);
      });

      test('should fail when request fail for PoleEmploi', () {
        sut.givenStore = givenState() //
            .loggedInPoleEmploiUser()
            .store((f) => {f.accueilRepository = AccueilRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldNotHaveCampagne()]);
      });
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
        initialState: loggedInState().copyWith(campagneState: CampagneState(mockCampagne(), [])),
      );
    });

    test('On first answer, post first answer to repository', () async {
      // When
      await store.dispatch(CampagneAnswerAction(1, 2, 'pourquoi-question-1'));

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
      await store.dispatch(CampagneAnswerAction(1, 2, 'pourquoi-question-1'));

      // When
      await store.dispatch(CampagneAnswerAction(2, 3, null));

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
      await store.dispatch(CampagneAnswerAction(1, 2, 'pourquoi-question-1'));

      // When
      await store.dispatch(CampagneAnswerAction(1, 2, 'nouveau-pourquoi-question-1'));

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
          campagneState: CampagneState(campagne(), [CampagneQuestionAnswer(1, 2, null)]),
        ),
      );

      // When
      await store.dispatch(CampagneResetAction());

      // Then
      final state = store.state;
      expect(state.campagneState.campagne, isNull);
      expect(state.campagneState.answers, isEmpty);
    });
  });
}

class CampagneRepositoryStub extends CampagneRepository {
  String? _userId;
  String? _campagneId;
  List<CampagneQuestionAnswer>? _updatedAnswers;

  CampagneRepositoryStub() : super(DioMock());

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
Matcher _shouldLoad() => StateIs<AccueilLoadingState>((state) => state.accueilState);

Matcher _shouldHaveCampagne() {
  return StateMatch(
    (state) => state.campagneState.campagne != null,
    (state) => expect(state.campagneState.campagne, mockCampagne()),
  );
}

Matcher _shouldNotHaveCampagne() {
  return StateMatch(
    (state) => state.campagneState.campagne == null,
  );
}
