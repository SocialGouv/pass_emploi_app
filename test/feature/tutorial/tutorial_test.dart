import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/tutorial_page.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test("Returns tutorial pages list when user didn't see the tutorial and logged in via MILO", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.tutorialState is TutorialLoadingState);

    final successState = store.onChange.firstWhere((e) => e.tutorialState is ShowTutorialState);

    // When
    store.dispatch(TutorialRequestAction());

    // Then
    expect(await displayedLoading, true);
    final successAppState = await successState;
    final dataState = (successAppState.tutorialState as ShowTutorialState);
    expect(dataState.pages, _miloTutorial());
  });

  test("Returns tutorial pages list when user didn't see the tutorial and logged in via Pole Emploi", () async {
    // Given
    final store = givenState()
        .loggedInPoleEmploiUser()
        .store((factory) => {factory.tutorialRepository = TutorialRepositorySuccessStub()});

    final displayedLoading = store.onChange.any((e) => e.tutorialState is TutorialLoadingState);

    final successState = store.onChange.firstWhere((e) => e.tutorialState is ShowTutorialState);

    // When
    store.dispatch(TutorialRequestAction());

    // Then
    expect(await displayedLoading, true);
    final successAppState = await successState;
    final dataState = (successAppState.tutorialState as ShowTutorialState);
    expect(dataState.pages, _poleEmploiTutorial());
  });

  // todo 810
  test("Returns empty tutorial pages list when user skipped the tutorial before", () async {});
  test("Returns tutorial pages list when user delayed the tutorial before", () async {});
}

class TutorialRepositorySuccessStub extends TutorialRepository {
  @override
  Future<List<TutorialPage>> getMiloTutorial() async {
    return _miloTutorial();
  }

  @override
  Future<List<TutorialPage>> getPoleEmploiTutorial() async {
    return _poleEmploiTutorial();
  }
}

List<TutorialPage> _miloTutorial() => [TutorialPage.milo.first];

List<TutorialPage> _poleEmploiTutorial() => [TutorialPage.poleEmploi.first];
