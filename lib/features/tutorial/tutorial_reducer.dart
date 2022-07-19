import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';

TutorialState tutorialReducer(TutorialState current, dynamic action) {
  if (action is TutorialRequestAction) return TutorialLoadingState();
  if (action is TutorialLoadingAction) return TutorialLoadingState();
  if (action is TutorialSuccessAction) return ShowTutorialState(action.pages);
  if (action is TutorialDelayedAction) return ShowTutorialState(action.pages);
  if (action is TutorialDoneAction) return TutorialNotInitializedState();
  if (action is TutorialSkippedAction) return TutorialNotInitializedState();
  return current;
}
