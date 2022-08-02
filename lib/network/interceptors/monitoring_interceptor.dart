import 'dart:io';

import 'package:flutterfire_installations/flutterfire_installations.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:redux/redux.dart';

class MonitoringInterceptor implements InterceptorContract {
  final InstallationIdRepository _repository;
  late Store<AppState> _store;
  String? _appVersion;
  String? _firebaseInstanceId;

  MonitoringInterceptor(this._repository);

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final loginState = _store.state.loginState;
    final String userId = loginState is LoginSuccessState ? loginState.user.id : 'NOT_LOGIN_USER';
    data.headers['X-UserId'] = userId;
    data.headers['X-InstallationId'] = await _repository.getInstallationId();
    data.headers['X-InstanceId'] = await _getFirebaseInstanceId();
    data.headers['X-CorrelationId'] = userId + '-' + DateTime.now().millisecondsSinceEpoch.toString();
    data.headers['X-AppVersion'] = await _getAppVersion();
    data.headers['X-Platform'] = Platform.operatingSystem;
    if (_isNotContainTypeValid(data)) data.headers['Content-Type'] = 'application/json; charset=utf-8';
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

  Future<String> _getFirebaseInstanceId() async {
    final firebaseInstanceIdCopy = _firebaseInstanceId;
    if (firebaseInstanceIdCopy != null) {
      return firebaseInstanceIdCopy;
    } else {
      final firebaseInstanceId = await FirebaseInstallations.instance.getId();
      _firebaseInstanceId = firebaseInstanceId;
      return firebaseInstanceId;
    }
  }

  bool _isNotContainTypeValid(RequestData data) {
    return data.headers['Content-Type'] == null || data.headers['Content-Type']!.contains("text/plain");
  }
}
