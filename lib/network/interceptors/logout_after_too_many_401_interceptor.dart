import 'package:dio/dio.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_interceptor.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:redux/redux.dart';

class LogoutAfterTooMany401Interceptor extends PassEmploiBaseInterceptor {
  final RemoteConfigRepository _remoteConfigRepository;

  LogoutAfterTooMany401Interceptor(RemoteConfigRepository remoteConfigRepository)
      : _remoteConfigRepository = remoteConfigRepository;

  late final Store<AppState> _store;
  int unauthorizedCount = 0;

  @override
  void onPassEmploiError(DioException err, ErrorInterceptorHandler handler) {
    final maxUnauthorizedErrorsBeforeLogout = _remoteConfigRepository.maxUnauthorizedErrorsBeforeLogout();

    if (maxUnauthorizedErrorsBeforeLogout == null) {
      handler.next(err);
      return;
    }

    if (err.response?.statusCode == 401) {
      unauthorizedCount++;
      if (unauthorizedCount >= maxUnauthorizedErrorsBeforeLogout) {
        _onUnauthorizedErrorCountExceeded();
      }
    } else {
      unauthorizedCount = 0;
    }
    handler.next(err);
  }

  void _onUnauthorizedErrorCountExceeded() {
    _store.dispatch(RequestLogoutAction(LogoutReason.tooMany401));
  }

  void setStore(Store<AppState> store) => _store = store;
}
