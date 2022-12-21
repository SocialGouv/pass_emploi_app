import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/page_actions.dart';

class PageActionRepository2 {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  PageActionRepository2(this._httpClient, [this._crashlytics]);

  Future<PageActions?> getPageActions(String userId) async {
    final url = "/jeunes/$userId/home/actions";
    try {
      final response = await _httpClient.get(url);
      return PageActions.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
