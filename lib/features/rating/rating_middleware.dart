import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rating/rating_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:pass_emploi_app/repositories/rating_repository.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class RatingMiddleware extends MiddlewareClass<AppState> {
  final RatingRepository _ratingRepository;
  final DetailsJeuneRepository _userRepository;

  RatingMiddleware(this._ratingRepository, this._userRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoginSuccessAction) {
      final loginState = store.state.loginState;
      if (loginState is LoginSuccessState) {
        final userId = loginState.user.id;
        final user = await _userRepository.get(userId);
        if (user != null && _shouldRate(user.conseiller.sinceDate)) {
          final showRating = await _ratingRepository.shouldShowRating();
          if (showRating) store.dispatch(ShowRatingAction());
        }
      }
    }
    if (action is RatingDoneAction) {
      await _ratingRepository.setRatingDone();
    }
  }

  bool _shouldRate(DateTime? sinceDate) {
    if (sinceDate != null) {
      return sinceDate.numberOfDaysUntilToday() > 30;
    }
    return false;
  }
}
