import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';

class AuthDioInterceptor extends Interceptor {
  final AuthAccessTokenRetriever _accessTokenRetriever;

  AuthDioInterceptor(this._accessTokenRetriever);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";
    handler.next(options);
  }
}
