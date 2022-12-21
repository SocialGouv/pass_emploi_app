import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';

class AuthInterceptor extends Interceptor {
  final AuthAccessTokenRetriever _accessTokenRetriever;

  AuthInterceptor(this._accessTokenRetriever);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";

    super.onRequest(options, handler);
  }
}
