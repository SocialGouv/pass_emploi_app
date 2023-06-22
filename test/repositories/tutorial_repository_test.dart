import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

import '../doubles/spies.dart';

void main() {
  final SharedPreferencesSpy prefs = SharedPreferencesSpy();
  final TutorialRepository repository = TutorialRepository(prefs);

  test("getMiloTutorial returns tutorial pages for MILO", () {
    // When
    final pages = repository.getMiloTutorial();

    // Then
    expect(pages, Tutorial.milo);
  });

  test("getMiloTutorial returns tutorial pages for Pole Emploi", () {
    // When
    final pages = repository.getPoleEmploiTutorial();

    // Then
    expect(pages, Tutorial.poleEmploi);
  });

  test("shouldShowTutorial returns true when user did not already saw it", () async {
    // When
    final shouldShowTutorial = await repository.shouldShowTutorial();

    // Then
    expect(shouldShowTutorial, isTrue);
  });

  test("shouldShowTutorial returns true when user already saw it", () async {
    // Given
    repository.setTutorialRead();

    // When
    final shouldShowTutorial = await repository.shouldShowTutorial();

    // Then
    expect(shouldShowTutorial, isFalse);
  });
}
