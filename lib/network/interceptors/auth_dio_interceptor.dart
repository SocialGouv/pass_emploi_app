import 'package:dio/dio.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_dio_interceptor.dart';

class AuthDioInterceptor extends PassEmploiBaseDioInterceptor {
  final AuthAccessTokenRetriever _accessTokenRetriever;

  AuthDioInterceptor(this._accessTokenRetriever);

  @override
  void onPassEmploiRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers["Authorization"] = "Bearer ${await _accessTokenRetriever.accessToken()}";
    handler.next(options);
  }
}
