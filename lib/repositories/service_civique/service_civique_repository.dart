import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class ServiceCiviqueDetailRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  ServiceCiviqueDetailRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  Future<ServiceCiviqueDetailResponse> getServiceCiviqueDetail(String idOffre) async {
    final url = Uri.parse(_baseUrl + "/services-civique/$idOffre");
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());
      if (response.statusCode.isValid()) {
        final Map<dynamic, dynamic> json = jsonUtf8Decode(response.bodyBytes) as Map<dynamic, dynamic>;
        return SuccessfullServiceCiviqueDetailResponse(ServiceCiviqueDetail.fromJson(json));
      } else {
        return NotFoundServiceCiviqueDetailResponse();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return FailedServiceCiviqueDetailResponse();
  }
}

abstract class ServiceCiviqueDetailResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuccessfullServiceCiviqueDetailResponse extends ServiceCiviqueDetailResponse {
  final ServiceCiviqueDetail detail;

  SuccessfullServiceCiviqueDetailResponse(this.detail);

  @override
  List<Object?> get props => [detail];
}

class NotFoundServiceCiviqueDetailResponse extends ServiceCiviqueDetailResponse {}

class FailedServiceCiviqueDetailResponse extends ServiceCiviqueDetailResponse {}
