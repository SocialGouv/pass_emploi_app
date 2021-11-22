import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiRepository {
  static const PAGE_SIZE = 50;

  final String _baseUrl;
  final HeadersBuilder _headerBuilder;

  OffreEmploiRepository(this._baseUrl, this._headerBuilder);

  Future<OffreEmploiSearchResponse?> search({
    required String userId,
    required String keywords,
    required String department,
    required int page,
  }) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi");
    final urlWithQuery = url.replace(queryParameters: {
      "q": keywords,
      "departement": department,
      "page": page.toString(),
      "limit": PAGE_SIZE.toString(),
    });
    try {
      final response = await http.get(
        urlWithQuery,
        headers: await _headerBuilder.headers(userId: userId),
      );
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        var list = (json["results"] as List).map((offre) => OffreEmploi.fromJson(offre)).toList();
        return OffreEmploiSearchResponse(
          isMoreDataAvailable: list.length == PAGE_SIZE,
          offres: list,
        );
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}

class OffreEmploiSearchResponse {
  final bool isMoreDataAvailable;
  final List<OffreEmploi> offres;

  OffreEmploiSearchResponse({required this.isMoreDataAvailable, required this.offres});
}
