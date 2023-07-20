import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/session_milo_details.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class SessionMiloRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  SessionMiloRepository(this._httpClient, [this._crashlytics]);

  Future<List<SessionMilo>?> getList(String userId) async {
    final url = "/jeunes/milo/$userId/sessions";
    try {
      final response = await _httpClient.get(url);
      return response.asListOf((session) => SessionMilo.fromJson(session));
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<SessionMiloDetails?> getDetails({required String userId, required String sessionId}) async {
    final url = "/jeunes/milo/$userId/sessions/$sessionId";
    try {
      final response = await _httpClient.get(url);
      return SessionMiloDetails.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
