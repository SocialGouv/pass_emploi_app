import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';

class ImmersionDetailsRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  ImmersionDetailsRepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<OffreDetailsResponse<ImmersionDetails>> fetch(String offreId) async {
    final url = Uri.parse(_baseUrl + "/offres-immersion/$offreId");
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers());
      if (response.statusCode.isValid()) {
        return OffreDetailsResponse(
          isGenericFailure: false,
          isOffreNotFound: false,
          details: ImmersionDetails.fromJson(jsonUtf8Decode(response.bodyBytes)),
        );
      } else {
        return OffreDetailsResponse<ImmersionDetails>(
          isGenericFailure: false,
          isOffreNotFound: true,
          details: null,
        );
      }
    } catch (e, stack) {
      if (e is HttpExceptionWithStatus && e.statusCode == 404) {
        return OffreDetailsResponse<ImmersionDetails>(
          isGenericFailure: false,
          isOffreNotFound: true,
          details: null,
        );
      }
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return OffreDetailsResponse<ImmersionDetails>(
      isGenericFailure: true,
      isOffreNotFound: false,
      details: null,
    );
  }
}
