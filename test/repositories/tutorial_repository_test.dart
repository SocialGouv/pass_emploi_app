import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/tutorial.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

import '../doubles/spies.dart';

void main() {
  final SharedPreferencesSpy prefs = SharedPreferencesSpy();
  final TutorialRepository repository = TutorialRepository(prefs);

  test("Returns tutorial pages for MILO when user didn't saw it yet", () async {
    // When
    final pages = await repository.getMiloTutorial();

    // Then
    expect(pages, Tutorial.milo);
  });

  test("Returns tutorial pages for Pole Emploi when user didn't saw it yet", () async {
    // When
    final pages = await repository.getPoleEmploiTutorial();

    // Then
    expect(pages, Tutorial.poleEmploi);
  });

  test("Returns empty tutorial pages for MILO when user already saw it yet", () async {
    // Given
    repository.setTutorialRead();

    // When
    final pages = await repository.getMiloTutorial();

    // Then
    expect(pages, isEmpty);
  });

  test("Returns empty tutorial pages for Pole Emploi when user already saw it yet", () async {
    // Given
    repository.setTutorialRead();

    // When
    final pages = await repository.getPoleEmploiTutorial();

    // Then
    expect(pages, isEmpty);
  });
}
