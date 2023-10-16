import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_dio_interceptor.dart';

class ExpiredTokenDioInterceptor extends PassEmploiBaseDioInterceptor {
  final AuthAccessChecker _authAccessChecker;

  ExpiredTokenDioInterceptor(this._authAccessChecker);

  @override
  void onPassEmploiError(DioException err, ErrorInterceptorHandler handler) {
    const missing_http_code = -1;
    _authAccessChecker.logoutUserIfTokenIsExpired(
      err.response?.toString(),
      err.response?.statusCode ?? missing_http_code,
    );
    handler.next(err);
  }
}
