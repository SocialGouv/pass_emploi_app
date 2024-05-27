import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';

class RendezvousRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  RendezvousRepository(this._httpClient, [this._crashlytics]);

  Future<Rendezvous?> getRendezvousPoleEmploi(String userId, String rendezvousId) async {
    final url = "/v2/jeunes/$userId/rendezvous?periode=FUTURS";
    try {
      final response = await _httpClient.get(url);
      final rdvs = response.asListOfWithKey("resultat", (event) => JsonRendezvous.fromJson(event).toRendezvous());
      return rdvs.firstWhereOrNull((rdv) => rdv.id == rendezvousId);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<Rendezvous?> getRendezvousMilo(String userId, String rendezvousId) async {
    final url = "/jeunes/$userId/rendezvous/$rendezvousId";
    try {
      final response = await _httpClient.get(url);
      return JsonRendezvous.fromJson(response.data).toRendezvous();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
