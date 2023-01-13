import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';

class ExpiredTokenInterceptor extends Interceptor {
  final AuthAccessChecker _authAccessChecker;

  ExpiredTokenInterceptor(this._authAccessChecker);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _authAccessChecker.logoutUserIfTokenIsExpired(err.response?.toString(), err.response?.statusCode ?? 700);
    handler.next(err);
  }
}
