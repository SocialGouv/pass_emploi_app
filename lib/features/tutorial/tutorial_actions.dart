import 'package:pass_emploi_app/models/tutorial/tutorial.dart';

class TutorialSuccessAction {
  final List<Tutorial> pages;

  TutorialSuccessAction(this.pages);
}

class TutorialDoneAction {}

class TutorialDelayedAction {}
