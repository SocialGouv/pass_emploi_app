import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_auth_repository.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_token_repository.dart';
import 'package:redux/redux.dart';

class PoleEmploiAuthMiddleware extends MiddlewareClass<AppState> {
  final PoleEmploiAuthRepository _repository;
  final PoleEmploiTokenRepository _tokenRepository;

  PoleEmploiAuthMiddleware(this._repository, this._tokenRepository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (_shouldGetToken(action)) {
      final token = await _repository.getPoleEmploiToken();
      if (token != null) _tokenRepository.setPoleEmploiAuthToken(token);
    } else if (_shouldClearToken(action)) {
      _tokenRepository.clearPoleEmploiAuthToken();
    }
  }

  bool _shouldGetToken(dynamic action) {
    return action is LoginSuccessAction && action.user.loginMode == LoginMode.POLE_EMPLOI;
  }

  bool _shouldClearToken(dynamic action) {
    return (action is LoginSuccessAction && action.user.loginMode != LoginMode.POLE_EMPLOI) ||
        action is RequestLogoutAction;
  }
}
