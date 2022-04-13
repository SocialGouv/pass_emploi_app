import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/mon_conseiller_info.dart';

class ConseillerRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  ConseillerRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<MonConseillerInfo?> fetch() async {
    return null;
  }

  bool temporarySilenceFlutterAnalyze() {
    // will be remove when story is done
    return (_baseUrl == "0" && _httpClient.runtimeType != Object && _crashlytics.runtimeType != Object);
  }
}
