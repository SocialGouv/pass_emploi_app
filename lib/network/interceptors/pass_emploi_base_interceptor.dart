import 'package:dio/dio.dart';

abstract class PassEmploiBaseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.isPassEmploiRequest()) {
      onPassEmploiRequest(options, handler);
    } else {
      handler.next(options);
    }
  }

  void onPassEmploiRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.isPassEmploiRequest()) {
      onPassEmploiResponse(response, handler);
    } else {
      handler.next(response);
    }
  }

  void onPassEmploiResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.isPassEmploiRequest()) {
      onPassEmploiError(err, handler);
    } else {
      handler.next(err);
    }
  }

  void onPassEmploiError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

extension RequestOptionsExtension on RequestOptions {
  bool isPassEmploiRequest() => uri.host == Uri.parse(baseUrl).host;
}
