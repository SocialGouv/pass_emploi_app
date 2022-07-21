import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';

TutorialState tutorialReducer(TutorialState current, dynamic action) {
  if (action is TutorialSuccessAction) return ShowTutorialState(action.pages);
  if (action is TutorialDelayedAction) return TutorialNotInitializedState();
  if (action is TutorialDoneAction) return TutorialNotInitializedState();
  return current;
}
