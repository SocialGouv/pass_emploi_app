import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_interceptor.dart';

class CacheInterceptor extends PassEmploiBaseInterceptor {
  final DioCacheInterceptor _decorated;

  CacheInterceptor(this._decorated);

  @override
  void onPassEmploiRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.shouldCache()) {
      _decorated.onRequest(options, handler);
    } else {
      super.onPassEmploiRequest(options, handler);
    }
  }

  @override
  void onPassEmploiResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.shouldCache()) {
      _decorated.onResponse(response, handler);
    } else {
      super.onPassEmploiResponse(response, handler);
    }
  }

  @override
  void onPassEmploiError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.shouldCache()) {
      _decorated.onError(err, handler);
    } else {
      super.onPassEmploiError(err, handler);
    }
  }
}

extension on RequestOptions {
  bool shouldCache() => !_isMonSuiviRequest() && !_isCvmTokenRequest();

  bool _isMonSuiviRequest() => uri.toString().contains('mon-suivi');

  bool _isCvmTokenRequest() => uri.toString().contains('idp-token');
}
