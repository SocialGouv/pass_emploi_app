import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';

class ExpiredTokenDioInterceptor extends Interceptor {
  final AuthAccessChecker _authAccessChecker;

  ExpiredTokenDioInterceptor(this._authAccessChecker);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    const missing_http_code = -1;
    _authAccessChecker.logoutUserIfTokenIsExpired(
      err.response?.toString(),
      err.response?.statusCode ?? missing_http_code,
    );
    handler.next(err);
  }
}
