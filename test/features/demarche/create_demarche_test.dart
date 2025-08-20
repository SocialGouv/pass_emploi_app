import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group('when creating a demarche', () {
    sut.whenDispatchingAction(() => CreateDemarcheRequestAction(
          codeQuoi: 'codeQuoi',
          codePourquoi: 'codePourquoi',
          codeComment: 'codeComment',
          dateEcheance: DateTime(2022),
          estDuplicata: false,
        ));

    group('when request succeeds', () {
      test('should display loading and success', () async {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser()
            .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldSucceedState()]);
      });
    });

    group('when request fails', () {
      test('should display loading and failure', () async {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser()
            .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositoryFailureStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldFailState()]);
      });
    });
  });

  group('when creating a demarche personnalisee', () {
    sut.whenDispatchingAction(() => CreateDemarchePersonnaliseeRequestAction('commentaire', DateTime(2022), false));

    group('when request succeeds', () {
      test('should display loading and success', () async {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser()
            .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositorySuccessStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldSucceedState()]);
      });
    });

    group('when request fails', () {
      test('should display loading and failure', () async {
        sut.givenStore = givenState()
            .loggedInPoleEmploiUser()
            .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositoryFailureStub()});
        sut.thenExpectChangingStatesThroughOrder([_shouldLoadState(), _shouldFailState()]);
      });
    });
  });

  test('on reset action, demarche state is properly reset', () async {
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(createDemarcheState: CreateDemarcheSuccessState('DEMARCHE-ID'))
        .store();

    // When
    await store.dispatch(CreateDemarcheResetAction());

    // Then
    expect(store.state.createDemarcheState, isA<CreateDemarcheNotInitializedState>());
  });
}

Matcher _shouldLoadState() => StateIs<CreateDemarcheLoadingState>((state) => state.createDemarcheState);

Matcher _shouldSucceedState() {
  return StateIs<CreateDemarcheSuccessState>(
    (state) => state.createDemarcheState,
    (state) => expect(state.demarcheCreatedId, 'DEMARCHE-ID'),
  );
}

Matcher _shouldFailState() => StateIs<CreateDemarcheFailureState>((state) => state.createDemarcheState);

class CreateDemarcheRepositorySuccessStub extends CreateDemarcheRepository {
  CreateDemarcheRepositorySuccessStub() : super(DioMock());

  @override
  Future<DemarcheId?> createDemarche({
    required String userId,
    required String codeQuoi,
    required String codePourquoi,
    required String? codeComment,
    required DateTime dateEcheance,
    required bool estDuplicata,
    required bool genereParIA,
  }) async {
    final success = userId == 'id' &&
        codeQuoi == 'codeQuoi' &&
        codePourquoi == 'codePourquoi' &&
        codeComment == 'codeComment' &&
        dateEcheance == DateTime(2022);
    return success ? 'DEMARCHE-ID' : null;
  }

  @override
  Future<DemarcheId?> createDemarchePersonnalisee({
    required String userId,
    required String commentaire,
    required DateTime dateEcheance,
    required bool estDuplicata,
  }) async {
    final success = commentaire == 'commentaire' && dateEcheance == DateTime(2022) && userId == 'id';
    return success ? 'DEMARCHE-ID' : null;
  }
}

class CreateDemarcheRepositoryFailureStub extends CreateDemarcheRepository {
  CreateDemarcheRepositoryFailureStub() : super(DioMock());

  @override
  Future<DemarcheId?> createDemarche({
    required String userId,
    required String codeQuoi,
    required String codePourquoi,
    required String? codeComment,
    required DateTime dateEcheance,
    required bool estDuplicata,
    required bool genereParIA,
  }) async {
    return null;
  }

  @override
  Future<DemarcheId?> createDemarchePersonnalisee({
    required String userId,
    required String commentaire,
    required DateTime dateEcheance,
    required bool estDuplicata,
  }) async {
    return null;
  }
}
