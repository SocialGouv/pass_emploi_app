import 'package:dio/dio.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';

class LogoutInterceptor implements InterceptorContract {
  final AuthAccessChecker _authAccessChecker;

  LogoutInterceptor(this._authAccessChecker);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    _authAccessChecker.logoutUserIfTokenIsExpired(data.body, data.statusCode);
    return data;
  }
}

class LogoutInterceptor2 extends Interceptor {
  final AuthAccessChecker _authAccessChecker;

  LogoutInterceptor2(this._authAccessChecker);

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    //TODO: vérifier que c'est OK
    _authAccessChecker.logoutUserIfTokenIsExpired(response.toString(), response.statusCode ?? 700);
    handler.next(response);
  }
}
