import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_interceptor.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/app_version_repository.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:redux/redux.dart';

class MonitoringInterceptor extends PassEmploiBaseInterceptor {
  final InstallationIdRepository _installationIdRepository;
  final AppVersionRepository _appVersionRepository;
  late Store<AppState> _store;

  MonitoringInterceptor(this._installationIdRepository, this._appVersionRepository);

  @override
  void onPassEmploiRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final userId = _store.state.userId() ?? 'NOT_LOGIN_USER';
    options.headers['X-UserId'] = userId;
    options.headers['X-InstallationId'] = await _installationIdRepository.getInstallationId();
    options.headers['X-CorrelationId'] = userId + '-' + DateTime.now().millisecondsSinceEpoch.toString();
    options.headers['X-AppVersion'] = await _appVersionRepository.getAppVersion();
    options.headers['X-Platform'] = Platform.operatingSystem;
    if (_contentTypeIsNotValid(options)) options.headers['Content-Type'] = 'application/json; charset=utf-8';
    handler.next(options);
  }

  void setStore(Store<AppState> store) => _store = store;

  bool _contentTypeIsNotValid(RequestOptions options) {
    final contentType = options.headers['Content-Type'] as String?;
    return contentType == null || contentType.contains("text/plain");
  }
}
