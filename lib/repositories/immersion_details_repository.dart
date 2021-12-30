import 'package:http/http.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/repository.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class ImmersionDetailsRepository implements Repository<String, ImmersionDetails> {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;

  ImmersionDetailsRepository(this._baseUrl, this._httpClient, this._headerBuilder);

  @override
  Future<ImmersionDetails?> fetch(String userId, String request) async {
    final url = Uri.parse(_baseUrl + "/offres-immersion/$request");
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) {
        return ImmersionDetails.fromJson(jsonUtf8Decode(response.bodyBytes));
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
