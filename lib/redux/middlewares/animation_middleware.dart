import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class AnimationMiddleware extends MiddlewareClass<AppState> {
  static const int _minAnimationTime = 1000;
  var _loadingStartingTime = 0;

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is HomeLoadingAction) {
      _loadingStartingTime = DateTime.now().millisecondsSinceEpoch;
    }
    if (action is HomeSuccessAction || action is HomeFailureAction) {
      final elapsedDuration = DateTime.now().millisecondsSinceEpoch - _loadingStartingTime;
      if (elapsedDuration < _minAnimationTime) {
        await new Future.delayed(new Duration(milliseconds: _minAnimationTime - elapsedDuration));
      }
    }
    next(action);
  }
}
