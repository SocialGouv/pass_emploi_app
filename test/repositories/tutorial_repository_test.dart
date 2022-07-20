import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/tutorial_repository.dart';

void main() {
  group("_getTutorial should return ...", () {
    final TutorialRepository repository = TutorialRepository();

    test("tutorial pages list for MILO", () async {
      final pages = await repository.getMiloTutorial();
      expect(pages.length, 2);
      expect(pages.first.title, "Trouvez plus facilement des offres d’emploi pour débutant");
    });

    test("tutorial pages list for Pole Emploi", () async {
      final pages = await repository.getPoleEmploiTutorial();
      expect(pages.length, 2);
      expect(pages.first.title, "Trouvez plus facilement des offres d’emploi pour débutant");
    });
  });
}
