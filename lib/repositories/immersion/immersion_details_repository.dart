import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';

class ImmersionDetailsRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  ImmersionDetailsRepository(this._httpClient, [this._crashlytics]);

  Future<OffreDetailsResponse<ImmersionDetails>> fetch(String offreId) async {
    final url = '/offres-immersion/$offreId';
    try {
      final response = await _httpClient.get(url);
      return OffreDetailsResponse(
        isGenericFailure: false,
        isOffreNotFound: false,
        details: ImmersionDetails.fromJson(response.data),
      );
    } catch (e, stack) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        return OffreDetailsResponse<ImmersionDetails>(
          isGenericFailure: false,
          isOffreNotFound: true,
          details: null,
        );
      }
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return OffreDetailsResponse<ImmersionDetails>(
      isGenericFailure: true,
      isOffreNotFound: false,
      details: null,
    );
  }
}
