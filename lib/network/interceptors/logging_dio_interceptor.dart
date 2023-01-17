import 'package:dio/dio.dart';
import 'package:pass_emploi_app/utils/log.dart';

class LoggingNetworkDioInterceptor extends Interceptor {
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    Log.i("Response from ${response.realUri.toString()} (code ${response.statusCode}): ${response.toString()}");
    handler.next(response);
  }
}
