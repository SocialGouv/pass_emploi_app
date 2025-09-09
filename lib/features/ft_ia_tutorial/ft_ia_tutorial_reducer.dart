import 'package:pass_emploi_app/features/ft_ia_tutorial/ft_ia_tutorial_actions.dart';
import 'package:pass_emploi_app/features/ft_ia_tutorial/ft_ia_tutorial_state.dart';

FtIaTutorialState ftIaTutorialReducer(FtIaTutorialState current, dynamic action) {
  if (action is FtIaTutorialSuccessAction) return FtIaTutorialState(action.result);
  return current;
}
