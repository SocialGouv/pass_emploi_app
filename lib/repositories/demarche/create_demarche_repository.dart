import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_create_demarche.dart';

typedef DemarcheId = String;

class CreateDemarcheRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  CreateDemarcheRepository(this._httpClient, [this._crashlytics]);

  Future<DemarcheId?> createDemarche({
    required String userId,
    required String codeQuoi,
    required String codePourquoi,
    required String? codeComment,
    required DateTime dateEcheance,
    required bool estDuplicata,
  }) async {
    final url = "/jeunes/$userId/demarches";
    try {
      final response = await _httpClient.post(
        url,
        data: customJsonEncode(
          PostCreateDemarche(
            codeQuoi: codeQuoi,
            codePourquoi: codePourquoi,
            codeComment: codeComment,
            dateEcheance: dateEcheance,
            estDuplicata: estDuplicata,
          ),
        ),
      );
      return response.data['id'] as String;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<DemarcheId?> createDemarchePersonnalisee({
    required String userId,
    required String commentaire,
    required DateTime dateEcheance,
    required bool estDuplicata,
  }) async {
    final url = "/jeunes/$userId/demarches";
    try {
      final response = await _httpClient.post(
        url,
        data: customJsonEncode(PostCreateDemarchePersonnalisee(commentaire, dateEcheance, estDuplicata)),
      );
      return response.data['id'] as String;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
