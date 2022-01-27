import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreDetailsResponse<T> {
  final bool isGenericFailure;
  final bool isOffreNotFound;
  final T? details;

  OffreDetailsResponse({required this.isGenericFailure, required this.isOffreNotFound, this.details});
}

class OffreEmploiDetailsRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  OffreEmploiDetailsRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  Future<OffreDetailsResponse<OffreEmploiDetails>> getOffreEmploiDetails({required String offreId}) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi/$offreId");
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        if (json.containsKey("data")) {
          return OffreDetailsResponse(
            isGenericFailure: false,
            isOffreNotFound: false,
            details: OffreEmploiDetails.fromJson(json["data"], json["urlRedirectPourPostulation"]),
          );
        }
      } else {
        return OffreDetailsResponse<OffreEmploiDetails>(
          isGenericFailure: false,
          isOffreNotFound: true,
          details: null,
        );
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return OffreDetailsResponse<OffreEmploiDetails>(
      isGenericFailure: true,
      isOffreNotFound: false,
      details: null,
    );
  }
}
