import 'package:dio/dio.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_interceptor.dart';

class RetryInterceptor extends PassEmploiBaseInterceptor {
  @override
  void onPassEmploiError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.method == 'POST' && err.requestOptions.uri.path.contains('action')) {
      final action = UserAction.fromPostPayload(err.requestOptions.data.toString());
      handler.resolve(
        Response(
          data: {'id': action.id, 'local': true},
          statusCode: 201,
          requestOptions: err.requestOptions,
        ),
      );
    } else {
      super.onPassEmploiError(err, handler);
    }
  }
}
