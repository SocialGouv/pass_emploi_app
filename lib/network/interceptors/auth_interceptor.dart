import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_interceptor.dart';

class AuthInterceptor extends PassEmploiBaseInterceptor {
  final AuthAccessTokenRetriever _accessTokenRetriever;

  AuthInterceptor(this._accessTokenRetriever);

  @override
  void onPassEmploiRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      options.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";
      handler.next(options);
    } catch (error, stacktrace) {
      handler.reject(DioException(requestOptions: options, error: error, stackTrace: stacktrace), true);
    }
  }
}
