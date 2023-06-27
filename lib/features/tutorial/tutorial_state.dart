import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

abstract class TutorialState {}

class TutorialNotInitializedState extends TutorialState {}

class ShowTutorialState extends TutorialState {
  final List<TutorialPage> pages;

  ShowTutorialState(this.pages);
}
