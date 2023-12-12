import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';

class LogoutRepository {
  final String authIssuer;
  final String clientSecret;
  final String clientId;
  final Crashlytics? crashlytics;
  late Dio _httpClient;
  late PassEmploiCacheManager _cacheManager;

  LogoutRepository({
    required this.authIssuer,
    required this.clientSecret,
    required this.clientId,
    this.crashlytics,
  });

  Future<void> logout(String refreshToken, String userId, LogoutReason reason) async {
    final url = '$authIssuer/protocol/openid-connect/logout';
    try {
      await _httpClient.post(
        url,
        data: 'client_id=$clientId&refresh_token=$refreshToken&client_secret=$clientSecret',
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
    } catch (e, stack) {
      crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    } finally {
      _cacheManager.emptyCache();
    }
    await _traceLogoutReasonToElastic(userId, reason);
  }

  void setHttpClient(Dio httpClient) {
    _httpClient = httpClient;
  }

  void setCacheManager(PassEmploiCacheManager cacheManager) {
    _cacheManager = cacheManager;
  }

  Future<void> _traceLogoutReasonToElastic(String userId, LogoutReason reason) async {
    try {
      await _httpClient.post('/app/logs/logout/$userId/$reason');
    } catch (_) {}
  }
}
