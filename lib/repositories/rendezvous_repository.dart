import 'package:http/http.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/repository.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class RendezvousRepository implements Repository<void, List<Rendezvous>> {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;

  RendezvousRepository(this._baseUrl, this._httpClient, this._headerBuilder);

  @override
  Future<List<Rendezvous>?> fetch(String userId, void request) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/home");
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json['rendezvous'] as List).map((rdv) => Rendezvous.fromJson(rdv)).toList();
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
