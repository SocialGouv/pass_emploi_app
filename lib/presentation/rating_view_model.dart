import 'package:pass_emploi_app/features/rating/rating_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:redux/redux.dart';

class RatingViewModel {
  final Function() onDone;
  final bool shouldSendEmailOnNegativeRating;

  RatingViewModel._({required this.onDone, required this.shouldSendEmailOnNegativeRating});

  factory RatingViewModel.create(Store<AppState> store, Platform platform) {
    final isBrsa = store.state.configurationState.getBrand().isBrsa;
    return RatingViewModel._(
      onDone: () => store.dispatch(RatingDoneAction()),
      shouldSendEmailOnNegativeRating: !(isBrsa && platform.isIos),
    );
  }
}
