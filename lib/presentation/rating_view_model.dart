import 'package:pass_emploi_app/features/rating/rating_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RatingViewModel {
  final Function() onDone;

  RatingViewModel._({required this.onDone});

  factory RatingViewModel.create(Store<AppState> store) {
    return RatingViewModel._(
      onDone: () => store.dispatch(RatingDoneAction()),
    );
  }
}
