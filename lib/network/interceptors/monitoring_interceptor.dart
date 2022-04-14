import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class MonitoringInterceptor implements InterceptorContract {
  late Store<AppState> _store;
  String? _appVersion;

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final loginState = _store.state.loginState;
    final String userId = loginState is LoginSuccessState ? loginState.user.id : 'NOT_LOGIN_USER';
    data.headers['X-InstallationId'] = userId;
    data.headers['X-CorrelationId'] = userId + '-' + DateTime.now().millisecondsSinceEpoch.toString();
    data.headers['X-AppVersion'] = await _getAppVersion();
    data.headers['X-Platform'] = Platform.operatingSystem;
    data.headers['Content-Type'] = 'application/json';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;

  void setStore(Store<AppState> store) => _store = store;

  Future<String> _getAppVersion() async {
    final appVersionCopy = _appVersion;
    if (appVersionCopy != null) {
      return appVersionCopy;
    } else {
      final appVersion = (await PackageInfo.fromPlatform()).version;
      _appVersion = appVersion;
      return appVersion;
    }
  }
}
