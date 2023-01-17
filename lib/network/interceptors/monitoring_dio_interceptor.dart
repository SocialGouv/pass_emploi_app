import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutterfire_installations/flutterfire_installations.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:redux/redux.dart';

class MonitoringDioInterceptor extends Interceptor {
  final InstallationIdRepository _repository;
  late Store<AppState> _store;
  String? _appVersion;
  String? _firebaseInstanceId;

  MonitoringDioInterceptor(this._repository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final userId = _store.state.userId() ?? 'NOT_LOGIN_USER';
    options.headers['X-UserId'] = userId;
    options.headers['X-InstallationId'] = await _repository.getInstallationId();
    options.headers['X-InstanceId'] = await _getFirebaseInstanceId();
    options.headers['X-CorrelationId'] = userId + '-' + DateTime.now().millisecondsSinceEpoch.toString();
    options.headers['X-AppVersion'] = await _getAppVersion();
    options.headers['X-Platform'] = Platform.operatingSystem;
    if (_contentTypeIsNotValid(options.headers)) options.headers['Content-Type'] = 'application/json; charset=utf-8';
    handler.next(options);
  }

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

  bool _contentTypeIsNotValid(Map<String, dynamic> headers) {
    //TODO: c'est pas tout en lowercase pour dio ?
    final contentType = headers['Content-Type'] as String?;
    return contentType == null || contentType.contains("text/plain");
  }
}
