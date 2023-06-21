import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';

class ServiceCiviqueDetailRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ServiceCiviqueDetailRepository(this._httpClient, [this._crashlytics]);

  Future<ServiceCiviqueDetailResponse> getServiceCiviqueDetail(String idOffre) async {
    final url = "/services-civique/$idOffre";
    try {
      final response = await _httpClient.get(url);
      return SuccessfullServiceCiviqueDetailResponse(ServiceCiviqueDetail.fromJson(response.data, idOffre));
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
      if (e is DioError && e.response?.statusCode != null) return NotFoundServiceCiviqueDetailResponse();
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
