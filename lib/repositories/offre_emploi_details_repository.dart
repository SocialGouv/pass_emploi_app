import 'package:http/http.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiDetailsRepository {
  final String _baseUrl;
  final Client _httpClient;

  OffreEmploiDetailsRepository(this._baseUrl, this._httpClient);

  Future<OffreEmploiDetails?> getOffreEmploiDetails({required String offreId}) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi/$offreId");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        if (json.containsKey("data")) OffreEmploiDetails.fromJson(json["data"]);
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
