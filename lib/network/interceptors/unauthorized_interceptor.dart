import 'package:dio/dio.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_interceptor.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class UnauthorizedInterceptor extends PassEmploiBaseInterceptor {
  late final Store<AppState> _store;

  UnauthorizedInterceptor();

  int unauthorizedCount = 0;

  static const int unauthorizedCountLimit = 10;

  @override
  void onPassEmploiError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      unauthorizedCount++;
      if (unauthorizedCount >= unauthorizedCountLimit) {
        _onUnauthorizedErrorCountExceeded();
      }
    }
    handler.next(err);
  }

  void _onUnauthorizedErrorCountExceeded() {
    _store.dispatch(RequestLogoutAction(LogoutReason.apiResponse401));
  }

  void setStore(Store<AppState> store) => _store = store;
}
