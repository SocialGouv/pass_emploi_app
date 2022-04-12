import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';
import 'package:pass_emploi_app/utils/log.dart';

class LogoutInterceptor implements InterceptorContract {
  final AuthAccessChecker _authAccessChecker;

  LogoutInterceptor(this._authAccessChecker);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    Log.i("BODY " + data.body.toString());
    Log.i("CODE " + data.statusCode.toString());
    _authAccessChecker.logoutUserIfTokenIsExpired(data.body, data.statusCode);
    return data;
  }
}
