import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class DetailedOfferRepository {
  final String baseUrl;

  DetailedOfferRepository(this.baseUrl);

  Future<DetailedOffer?> getDetailedOffer(String offerId) async {
    var url = Uri.parse(baseUrl + "/offres-emploi/$offerId");
    try {
      final response = await http.get(url);
      if (response.statusCode.isValid()) return DetailedOffer.fromJson(jsonUtf8Decode(response.bodyBytes));
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}