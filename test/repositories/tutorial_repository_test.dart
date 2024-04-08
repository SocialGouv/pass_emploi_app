import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

import '../doubles/spies.dart';

void main() {
  final SharedPreferencesSpy prefs = SharedPreferencesSpy();
  final TutorialRepository repository = TutorialRepository(prefs);

  setUp(() {
    prefs.reset();
  });

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
    expect(pages, Tutorial.pe);
  });

  test("shouldShowTutorial returns false on first launch", () async {
    // When
    final shouldShowTutorial = await repository.shouldShowTutorial();

    // Then
    expect(shouldShowTutorial, isFalse);
  });

  test("shouldShowTutorial returns true when not on first launch and user did not already saw it", () async {
    // Given
    await prefs.write(key: 'tutorialRead-111', value: 'read');

    // When
    final shouldShowTutorial = await repository.shouldShowTutorial();

    // Then
    expect(shouldShowTutorial, isTrue);
  });

  test("shouldShowTutorial returns false when user already saw it", () async {
    // Given
    repository.setTutorialRead();

    // When
    final shouldShowTutorial = await repository.shouldShowTutorial();

    // Then
    expect(shouldShowTutorial, isFalse);
  });
}
