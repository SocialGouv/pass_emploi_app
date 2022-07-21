import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/tutorial.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("Returns tutorial pages list when user didn't see the tutorial and logged in via MILO", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositorySuccessStub()});

    final successState = store.onChange.firstWhere((e) => e.tutorialState is ShowTutorialState);

    // When
    store.dispatch(LoginSuccessAction(mockedMiloUser()));

    // Then
    final successAppState = await successState;
    final dataState = (successAppState.tutorialState as ShowTutorialState);
    expect(dataState.pages, Tutorial.milo);
  });

  test("Returns tutorial pages list when user didn't see the tutorial and logged in via Pole Emploi", () async {
    // Given
    final store = givenState()
        .loggedInPoleEmploiUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositorySuccessStub()});

    final successState = store.onChange.firstWhere((e) => e.tutorialState is ShowTutorialState);

    // When
    store.dispatch(LoginSuccessAction(mockedPoleEmploiUser()));

    // Then
    final successAppState = await successState;
    final dataState = (successAppState.tutorialState as ShowTutorialState);
    expect(dataState.pages, Tutorial.poleEmploi);
  });

  test("Returns not initialized tutorial state when user already read the tutorial before", () async {
    // Given
    final store = givenState()
        .loggedInPoleEmploiUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositoryAlreadySeenStub()});

    // When
    await store.dispatch(LoginSuccessAction(mockedMiloUser()));

    // Then
    expect(store.state.tutorialState, isA<TutorialNotInitializedState>());
  });
}

class TutorialRepositorySuccessStub extends TutorialRepository {
  TutorialRepositorySuccessStub() : super(DummySharedPreferences());

  @override
  Future<List<Tutorial>> getMiloTutorial() async {
    return Tutorial.milo;
  }

  @override
  Future<List<Tutorial>> getPoleEmploiTutorial() async {
    return Tutorial.poleEmploi;
  }
}

class TutorialRepositoryAlreadySeenStub extends TutorialRepository {
  TutorialRepositoryAlreadySeenStub() : super(DummySharedPreferences());

  @override
  Future<List<Tutorial>> getMiloTutorial() async {
    return [];
  }
}
