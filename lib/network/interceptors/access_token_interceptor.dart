import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';

class AccessTokenInterceptor implements InterceptorContract {
  final AuthAccessTokenRetriever _accessTokenRetriever;

  AccessTokenInterceptor(this._accessTokenRetriever);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // TODO remove
    // return data;
    data.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}
