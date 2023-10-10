import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pass_emploi_app/utils/log.dart';

class LoggingNetworkDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.i("""Dio Request 
    - ${options.method} ${options.uri.toString()}
    - queryParams: ${options.queryParameters}
    - data: ${options.data}
    - headers: ${options.headers}
    """);
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    Log.i("""Dio Response 
    - ${response.requestOptions.method} ${response.realUri.toString()}:
    - queryParams: ${response.requestOptions.queryParameters}
    - fromNetwork: ${response.extra[CacheResponse.fromNetwork]}
    - cacheKey: ${response.extra[CacheResponse.cacheKey]}
    - data: ${response.requestOptions.data}
    - code: ${response.statusCode}
    - response: ${response.toString()}
    """);
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.i("""Dio Error 
    - ${err.requestOptions.method} ${err.requestOptions.uri.toString()}:
    - queryParams: ${err.requestOptions.queryParameters}
    - code: ${err.response?.statusCode}
    - response: ${err.response.toString()}
    """);
    handler.next(err);
  }
}
