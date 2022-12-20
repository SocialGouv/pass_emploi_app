import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:redux/redux.dart';

class RegisterPushNotificationTokenMiddleware extends MiddlewareClass<AppState> {
  final ConfigurationApplicationRepository _repository;

  RegisterPushNotificationTokenMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is LoginSuccessAction) {
      final fuseauHoraire = DateTime.now().timeZoneName;
      _repository.configureApplication(action.user.id, fuseauHoraire);
    }
  }
}
