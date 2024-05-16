import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/date/interval.dart';
import 'package:pass_emploi_app/models/mon_suivi.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class MonSuiviRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  MonSuiviRepository(this._httpClient, [this._crashlytics]);

  Future<MonSuivi?> getMonSuiviMilo(String userId, Interval interval) async {
    final url = "/jeunes/milo/$userId/mon-suivi";

    try {
      final response = await _httpClient.get(
        url,
        queryParameters: {
          "dateDebut": interval.debut.toIso8601WithOffsetDateTime(),
          "dateFin": interval.fin.toIso8601WithOffsetDateTime(),
        },
      );
      return MonSuivi.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<MonSuivi?> getMonSuiviPe(String userId, DateTime debut) async {
    final url = "/jeunes/pole-emploi/$userId/mon-suivi";

    try {
      final response = await _httpClient.get(
        url,
        queryParameters: {"dateDebut": debut.toIso8601WithOffsetDateTime()},
      );
      return MonSuivi.fromJson(response.data).copyWith(errorOnSessionMiloRetrieval: false);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
