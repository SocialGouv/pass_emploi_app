import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class ModifyDemarcheRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  ModifyDemarcheRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<UserActionPE?> modifyDemarche(
    String userId,
    String demarcheId,
    UserActionPEStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/demarches/$demarcheId/statut");
    try {
      final response = await _httpClient.put(url, body: {
        "statut": _statusToString(status),
        "dateFin": dateFin?.toIso8601String(),
        "dateDebut": dateDebut?.toIso8601String(),
      });
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return UserActionPE.fromJson(json);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  String _statusToString(UserActionPEStatus status) {
    switch (status) {
      case UserActionPEStatus.NOT_STARTED:
        return "A_FAIRE";
      case UserActionPEStatus.IN_PROGRESS:
        return "EN_COURS";
      case UserActionPEStatus.DONE:
        return "REALISEE";
      case UserActionPEStatus.CANCELLED:
        return "ANNULEE";
    }
  }
}
