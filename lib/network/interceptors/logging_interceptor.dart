import 'package:dio/dio.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:pass_emploi_app/utils/log.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    Log.i(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    Log.i(data.toString());
    return data;
  }
}

class LoggingInterceptor2 extends Interceptor {
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    Log.i("Response from ${response.realUri.toString()} (code ${response.statusCode}): ${response.toString()}");
    handler.next(response);
  }
}
