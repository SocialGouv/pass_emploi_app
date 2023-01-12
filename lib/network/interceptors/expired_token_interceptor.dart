import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';

class ExpiredTokenInterceptor extends Interceptor {
  final AuthAccessChecker _authAccessChecker;

  ExpiredTokenInterceptor(this._authAccessChecker);

  //TODO: vérifier que c'est OK. Et je pense qu'il faut qu'il soit juste dans onError.

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _authAccessChecker.logoutUserIfTokenIsExpired(response.toString(), response.statusCode ?? 777);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _authAccessChecker.logoutUserIfTokenIsExpired(err.response?.toString(), err.response?.statusCode ?? 700);
    handler.next(err);
  }
}
