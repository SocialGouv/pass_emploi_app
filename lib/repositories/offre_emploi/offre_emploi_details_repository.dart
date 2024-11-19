import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';

class OffreDetailsResponse<T> {
  final bool isGenericFailure;
  final bool isOffreNotFound;
  final T? details;

  OffreDetailsResponse({required this.isGenericFailure, required this.isOffreNotFound, this.details});
}

class OffreEmploiDetailsRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  OffreEmploiDetailsRepository(this._httpClient, [this._crashlytics]);

  Future<OffreDetailsResponse<OffreEmploiDetails>> getOffreEmploiDetails({required String offreId}) async {
    final url = "/offres-emploi/$offreId";
    try {
      final response = await _httpClient.get(url);
      final json = response.data as Map<dynamic, dynamic>;
      if (json.containsKey("data")) {
        return OffreDetailsResponse(
          isGenericFailure: false,
          isOffreNotFound: false,
          details: OffreEmploiDetails.from(
            json["data"] as Map<String, dynamic>,
            json["urlRedirectPourPostulation"] as String,
            Origin.fromJson(json),
          ),
        );
      }
    } catch (e, stack) {
      if (e is DioException) {
        return OffreDetailsResponse<OffreEmploiDetails>(
          isGenericFailure: false,
          isOffreNotFound: true,
          details: null,
        );
      }
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return OffreDetailsResponse<OffreEmploiDetails>(
      isGenericFailure: true,
      isOffreNotFound: false,
      details: null,
    );
  }
}
