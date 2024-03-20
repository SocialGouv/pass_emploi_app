import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:redux/redux.dart';

class PushNotificationRegisterTokenMiddleware extends MiddlewareClass<AppState> {
  final ConfigurationApplicationRepository _repository;
  final Configuration _configuration;

  PushNotificationRegisterTokenMiddleware(this._repository, this._configuration);

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is LoginSuccessAction) {
      _repository.configureApplication(action.user.id, _configuration.fuseauHoraire);
    }
  }
}
