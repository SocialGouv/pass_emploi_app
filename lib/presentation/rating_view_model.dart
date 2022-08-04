import 'package:pass_emploi_app/features/rating/rating_actions.dart';
import 'package:pass_emploi_app/features/rating/rating_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RatingViewModel {
  final bool show;
  final Function() onDone;

  RatingViewModel._({required this.show, required this.onDone});

  factory RatingViewModel.create(Store<AppState> store) {
    return RatingViewModel._(
      show: store.state.ratingState is ShowRatingState,
      onDone: () => store.dispatch(RatingDoneAction()),
    );
  }
}
