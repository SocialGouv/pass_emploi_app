import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/MonConseillerInfo.dart';
import 'package:pass_emploi_app/network/headers.dart';

class ConseillerRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  ConseillerRepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<MonConseillerInfo?> fetch() async {
    return null;
  }
}
