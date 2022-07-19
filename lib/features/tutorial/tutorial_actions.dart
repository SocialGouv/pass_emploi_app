import 'package:pass_emploi_app/models/tutorial_page.dart';

class TutorialRequestAction {}

class TutorialLoadingAction {}

class TutorialSuccessAction {
  final List<TutorialPage> pages;

  TutorialSuccessAction(this.pages);
}

class TutorialDoneAction {}

class TutorialDelayedAction {
  final List<TutorialPage> pages;

  TutorialDelayedAction(this.pages);
}

class TutorialSkippedAction {}