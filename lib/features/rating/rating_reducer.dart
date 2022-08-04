import 'package:pass_emploi_app/features/rating/rating_actions.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';

RatingState ratingReducer(RatingState current, dynamic action) {
  if (action is RatingSuccessAction) return ShowRatingState();
  if (action is RatingDoneAction) return RatingNotInitializedState();
  return current;
}
