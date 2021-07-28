import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class LoginMiddleware extends MiddlewareClass<AppState> {
  final UserRepository repository;

  LoginMiddleware(this.repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is BootstrapAction) {
      _logUser(next);
    } else {
      next(action);
    }
  }

  void _logUser(NextDispatcher next) async {
    final userId = await repository.getUserId();
    if (userId != null) {
      next(LoginCompletedAction(User(userId)));
    } else {
      final newUserId = _generateUserId();
      repository.setUserId(newUserId);
      next(LoginCompletedAction(User(newUserId)));
    }
  }

  String _generateUserId() => DateTime.now().hashCode.toString();
}
