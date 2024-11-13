import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

final List<TutorialPage> miloTutorials = [
  TutorialPage(title: 'title MILO', description: 'description MILO', image: 'image MILO')
];
final List<TutorialPage> poleEmploiTutorials = [
  TutorialPage(title: 'title PE', description: 'description PE', image: 'image PE')
];

void main() {
  final repository = MockTutorialRepository();

  test("Returns tutorial pages list when user didn't see the tutorial and logged in via MILO", () async {
    // Given
    when(() => repository.getMiloTutorial()).thenReturn(miloTutorials);
    when(() => repository.shouldShowTutorial()).thenAnswer((_) async => true);
    final store = givenState() //
        .loggedInMiloUser()
        .store((factory) => {factory.tutorialRepository = repository});

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
    when(() => repository.getPoleEmploiTutorial()).thenReturn(poleEmploiTutorials);
    when(() => repository.shouldShowTutorial()).thenAnswer((_) async => true);
    final store = givenState().loggedInPoleEmploiUser().store((factory) => {factory.tutorialRepository = repository});

    final successState = store.onChange.firstWhere((e) => e.tutorialState is ShowTutorialState);

    // When
    store.dispatch(LoginSuccessAction(mockedPoleEmploiCejUser()));

    // Then
    final successAppState = await successState;
    final dataState = (successAppState.tutorialState as ShowTutorialState);
    expect(dataState.pages, poleEmploiTutorials);
  });

  test("Returns not initialized tutorial state when user already read the tutorial before", () async {
    // Given
    when(() => repository.shouldShowTutorial()).thenAnswer((_) async => false);
    when(() => repository.setTutorialRead()).thenAnswer((_) async {});
    final store = givenState().loggedInPoleEmploiUser().store((factory) => {factory.tutorialRepository = repository});
    await store.dispatch(TutorialDoneAction());

    // When
    await store.dispatch(LoginSuccessAction(mockedMiloUser()));

    // Then
    expect(store.state.tutorialState, isA<TutorialNotInitializedState>());
  });
}

class TutorialRepositoryStub extends TutorialRepository {
  TutorialRepositoryStub() : super(FlutterSecureStorageSpy());

  @override
  List<TutorialPage> getMiloTutorial() => miloTutorials;

  @override
  List<TutorialPage> getPoleEmploiTutorial() => poleEmploiTutorials;
}
