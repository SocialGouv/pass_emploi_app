import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class EventListRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  EventListRepository(this._baseUrl, this._httpClient, [this._crashlytics]);
}
