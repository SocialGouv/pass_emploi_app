import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiDetailsResponse {
  final bool isGenericFailure;
  final bool isOffreNotFound;
  final OffreEmploiDetails? offreEmploiDetails;

  OffreEmploiDetailsResponse({required this.isGenericFailure, required this.isOffreNotFound, this.offreEmploiDetails});
}

class OffreEmploiDetailsRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;

  OffreEmploiDetailsRepository(this._baseUrl, this._httpClient, this._headersBuilder);

  Future<OffreEmploiDetailsResponse> getOffreEmploiDetails({required String offreId}) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi/$offreId");
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        if (json.containsKey("data")) {
          return OffreEmploiDetailsResponse(
            isGenericFailure: false,
            isOffreNotFound: false,
            offreEmploiDetails: OffreEmploiDetails.fromJson(json["data"], json["urlRedirectPourPostulation"]),
          );
        }
      } else {
        return OffreEmploiDetailsResponse(
          isGenericFailure: false,
          isOffreNotFound: true,
          offreEmploiDetails: null,
        );
      }
    } catch (e) {
      debugPrint('Exception on ${url.toString()}: ' + e.toString());
    }
    return OffreEmploiDetailsResponse(
      isGenericFailure: true,
      isOffreNotFound: false,
      offreEmploiDetails: null,
    );
  }
}
