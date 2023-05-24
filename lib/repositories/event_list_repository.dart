import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class EventListRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  EventListRepository(this._httpClient, [this._crashlytics]);

  Future<List<Rendezvous>?> get(String userId, DateTime maintenant) async {
    final date = Uri.encodeComponent(maintenant.toIso8601WithOffsetDateTime());
    final url = "/jeunes/$userId/animations-collectives?maintenant=$date";
    try {
      final response = await _httpClient.get(url);
      return (response.data as List).map((event) => JsonRendezvous.fromJson(event).toRendezvous()).toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
