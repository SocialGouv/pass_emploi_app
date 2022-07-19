import 'package:pass_emploi_app/models/tutorial_page.dart';

class TutorialRepository {
  Future<List<TutorialPage>> getMiloTutorial() async {
    return TutorialPage.milo.toList();
  }

  Future<List<TutorialPage>> getPoleEmploiTutorial() async {
    return TutorialPage.poleEmploi.toList();
  }

  // todo: 810 when we call le back?
  Future<void> tutorialDone() async {
    // call back
  }

  Future<void> tutorialSkipped() async {
    // call back
  }

}
