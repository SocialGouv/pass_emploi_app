import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/tutorial.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

final List<Tutorial> miloTutorials = [
  Tutorial(title: 'title MILO', description: 'description MILO', image: 'image MILO')
];
final List<Tutorial> poleEmploiTutorials = [
  Tutorial(title: 'title PE', description: 'description PE', image: 'image PE')
];

void main() {
  test("Returns tutorial pages list when user didn't see the tutorial and logged in via MILO", () async {
    // Given
    final store = givenState() //
        .loggedInMiloUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositoryStub()});

    final successState = store.onChange.firstWhere((e) => e.tutorialState is ShowTutorialState);

    // When
    store.dispatch(LoginSuccessAction(mockedMiloUser()));

    // Then
    final successAppState = await successState;
    final dataState = (successAppState.tutorialState as ShowTutorialState);
    expect(dataState.pages, miloTutorials);
  });

  test("Returns tutorial pages list when user didn't see the tutorial and logged in via Pole Emploi", () async {
    // Given
    final store = givenState()
        .loggedInPoleEmploiUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositoryStub()});

    final successState = store.onChange.firstWhere((e) => e.tutorialState is ShowTutorialState);

    // When
    store.dispatch(LoginSuccessAction(mockedPoleEmploiUser()));

    // Then
    final successAppState = await successState;
    final dataState = (successAppState.tutorialState as ShowTutorialState);
    expect(dataState.pages, poleEmploiTutorials);
  });

  test("Returns not initialized tutorial state when user already read the tutorial before", () async {
    // Given
    final store = givenState()
        .loggedInPoleEmploiUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositoryStub()});
    await store.dispatch(TutorialDoneAction());

    // When
    await store.dispatch(LoginSuccessAction(mockedMiloUser()));

    // Then
    expect(store.state.tutorialState, isA<TutorialNotInitializedState>());
  });
}

class TutorialRepositoryStub extends TutorialRepository {
  TutorialRepositoryStub() : super(SharedPreferencesSpy());

  @override
  List<Tutorial> getMiloTutorial() => miloTutorials;

  @override
  List<Tutorial> getPoleEmploiTutorial() => poleEmploiTutorials;
}
