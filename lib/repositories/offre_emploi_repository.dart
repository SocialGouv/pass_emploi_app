import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiRepository {
  final String _baseUrl;
  final HeadersBuilder _headerBuilder;

  OffreEmploiRepository(this._baseUrl, this._headerBuilder);

  Future<List<OffreEmploi>?> search({
    required String userId,
    required String keywords,
    required String department,
  }) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi");
    try {
      final response = await http.get(
        url,
        headers: await _headerBuilder.headers(userId: userId),
      );
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((offre) => OffreEmploi.fromJson(offre)).toList();
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
