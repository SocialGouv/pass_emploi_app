import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class UpdateDemarcheRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  UpdateDemarcheRepository(this._httpClient, [this._crashlytics]);

  Future<Demarche?> updateDemarche(
    String userId,
    String demarcheId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    final url = "/jeunes/$userId/demarches/$demarcheId/statut";
    try {
      final response = await _httpClient.put(
        url,
        data: jsonEncode({
          "statut": _statusToString(status),
          "dateFin": dateFin?.toIso8601WithOffsetDateTime(),
          "dateDebut": dateDebut?.toIso8601WithOffsetDateTime(),
        }),
      );
      return Demarche.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  String _statusToString(DemarcheStatus status) {
    switch (status) {
      case DemarcheStatus.pasCommencee:
        return "A_FAIRE";
      case DemarcheStatus.enCours:
        return "EN_COURS";
      case DemarcheStatus.terminee:
        return "REALISEE";
      case DemarcheStatus.annulee:
        return "ANNULEE";
    }
  }
}
