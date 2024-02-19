import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/rendezvous_list_result.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class RendezvousRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  RendezvousRepository(this._httpClient, [this._crashlytics]);

  Future<RendezvousListResult?> getRendezvousList(String userId, RendezvousPeriod period) async {
    final periodParam = period == RendezvousPeriod.PASSE ? "PASSES" : "FUTURS";
    final url = "/v2/jeunes/$userId/rendezvous?periode=$periodParam";

    try {
      final response = await _httpClient.get(url);
      return RendezvousListResult(
        rendezvous: response.asListOfWithKey("resultat", (event) => JsonRendezvous.fromJson(event).toRendezvous()),
        dateDerniereMiseAJour: (response.data["dateDerniereMiseAJour"] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      );
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
