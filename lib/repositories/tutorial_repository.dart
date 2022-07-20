import 'package:pass_emploi_app/models/tutorial_page.dart';

class TutorialRepository {
  Future<List<TutorialPage>> getMiloTutorial() async {
    return TutorialPage.milo.toList();
  }

  Future<List<TutorialPage>> getPoleEmploiTutorial() async {
    return TutorialPage.poleEmploi.toList();
  }
}
