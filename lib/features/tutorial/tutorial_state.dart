import 'package:pass_emploi_app/models/tutorial.dart';

abstract class TutorialState {}

class TutorialNotInitializedState extends TutorialState {}

class ShowTutorialState extends TutorialState {
  final List<Tutorial> pages;

  ShowTutorialState(this.pages);
}
