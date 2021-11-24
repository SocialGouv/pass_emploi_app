import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiDetailsRepository {
  final String baseUrl;

  OffreEmploiDetailsRepository(this.baseUrl);

  Future<DetailedOffer?> getOffreEmploiDetails({required String offerId}) async {
    final url = Uri.parse(baseUrl + "/offres-emploi/$offerId");
    try {
      final response = await http.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        if (json.containsKey("data")) {
          return DetailedOffer.fromJson(json["data"]);
        }
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
