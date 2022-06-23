import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';

import '../../doubles/dummies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('When creating a demarche', () {
    test('should update create demarche state with success', () async {
      // Given
      final store = givenState()
          .loggedInPoleEmploiUser()
          .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositorySuccessStub()});
      final displayedLoading = store.onChange.any((e) => e.createDemarcheState is CreateDemarcheLoadingState);
      final successAppState = store.onChange.firstWhere((e) => e.createDemarcheState is CreateDemarcheSuccessState);

      // When
      await store.dispatch(
        CreateDemarcheRequestAction(
          codeQuoi: 'codeQuoi',
          codePourquoi: 'codePourquoi',
          codeComment: 'codeComment',
          dateEcheance: DateTime(2022),
        ),
      );

      // Then
      expect(await displayedLoading, true);
      final appState = await successAppState;
      expect(appState.createDemarcheState is CreateDemarcheSuccessState, true);
    });

    test('should update create demarche state with failure', () async {
      // Given
      final store = givenState()
          .loggedInPoleEmploiUser()
          .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositoryFailureStub()});
      final displayedLoading = store.onChange.any((e) => e.createDemarcheState is CreateDemarcheLoadingState);
      final failureAppState = store.onChange.firstWhere((e) => e.createDemarcheState is CreateDemarcheFailureState);

      // When
      await store.dispatch(CreateDemarchePersonnaliseeRequestAction('commentaire', DateTime(2022)));

      // Then
      expect(await displayedLoading, true);
      final appState = await failureAppState;
      expect(appState.createDemarcheState is CreateDemarcheFailureState, true);
    });
  });

  group('When creating a demarche personnalisee', () {
    test('should update create demarche state with success', () async {
      // Given
      final store = givenState()
          .loggedInPoleEmploiUser()
          .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositorySuccessStub()});
      final displayedLoading = store.onChange.any((e) => e.createDemarcheState is CreateDemarcheLoadingState);
      final successAppState = store.onChange.firstWhere((e) => e.createDemarcheState is CreateDemarcheSuccessState);

      // When
      await store.dispatch(CreateDemarchePersonnaliseeRequestAction('commentaire', DateTime(2022)));

      // Then
      expect(await displayedLoading, true);
      final appState = await successAppState;
      expect(appState.createDemarcheState is CreateDemarcheSuccessState, true);
    });

    test('should update create demarche state with failure', () async {
      // Given
      final store = givenState()
          .loggedInPoleEmploiUser()
          .store((factory) => {factory.createDemarcheRepository = CreateDemarcheRepositoryFailureStub()});
      final displayedLoading = store.onChange.any((e) => e.createDemarcheState is CreateDemarcheLoadingState);
      final failureAppState = store.onChange.firstWhere((e) => e.createDemarcheState is CreateDemarcheFailureState);

      // When
      await store.dispatch(CreateDemarchePersonnaliseeRequestAction('commentaire', DateTime(2022)));

      // Then
      expect(await displayedLoading, true);
      final appState = await failureAppState;
      expect(appState.createDemarcheState is CreateDemarcheFailureState, true);
    });
  });

  test('on reset action, demarche state is properly reset', () async {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(createDemarcheState: CreateDemarcheSuccessState())
        .store();

    // When
    await store.dispatch(CreateDemarcheResetAction());

    // Then
    expect(store.state.createDemarcheState is CreateDemarcheNotInitializedState, true);
  });
}

class CreateDemarcheRepositorySuccessStub extends CreateDemarcheRepository {
  CreateDemarcheRepositorySuccessStub() : super('', DummyHttpClient());

  @override
  Future<bool> createDemarche({
    required String userId,
    required String codeQuoi,
    required String codePourquoi,
    required String? codeComment,
    required DateTime dateEcheance,
  }) async {
    return userId == 'id' &&
        codeQuoi == 'codeQuoi' &&
        codePourquoi == 'codePourquoi' &&
        codeComment == 'codeComment' &&
        dateEcheance == DateTime(2022);
  }

  @override
  Future<bool> createDemarchePersonnalisee({
    required String userId,
    required String commentaire,
    required DateTime dateEcheance,
  }) async {
    return commentaire == 'commentaire' && dateEcheance == DateTime(2022) && userId == 'id';
  }
}

class CreateDemarcheRepositoryFailureStub extends CreateDemarcheRepository {
  CreateDemarcheRepositoryFailureStub() : super('', DummyHttpClient());

  @override
  Future<bool> createDemarche({
    required String userId,
    required String codeQuoi,
    required String codePourquoi,
    required String? codeComment,
    required DateTime dateEcheance,
  }) async {
    return false;
  }

  @override
  Future<bool> createDemarchePersonnalisee({
    required String userId,
    required String commentaire,
    required DateTime dateEcheance,
  }) async {
    return false;
  }
}
