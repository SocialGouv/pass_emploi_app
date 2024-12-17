import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/in_app_notification.dart';

class InAppNotificationsRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  InAppNotificationsRepository(this._httpClient, [this._crashlytics]);

  Future<List<InAppNotification>?> get(String userId) async {
    final url = "/jeunes/$userId/notifications";
    try {
      final response = await _httpClient.get(url);
      return (response.data as List).map((json) => InAppNotification.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
