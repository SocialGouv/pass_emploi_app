import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/user_action_PE.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class UserActionPERepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  UserActionPERepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<List<UserActionPE>?> getUserActions(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/pole-emploi/actions");
    try {
      final response = await _httpClient.get(
        url,
        headers: await _headerBuilder.headers(userId: userId),
      );
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        (json as List).map((action) => print(action));
        return (json as List).map((action) => UserActionPE.fromJson(action)).toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
    // return [
    //   UserActionPE(
    //     id: "id",
    //     content: "content",
    //     status: UserActionPEStatus.NOT_STARTED,
    //     endDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     deletionDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     createdByAdvisor: true,
    //   ),
    //   UserActionPE(
    //     id: "id",
    //     content:
    //         "content very very very very very very very very very very very very very very very very very very very very long description",
    //     status: UserActionPEStatus.IN_PROGRESS,
    //     endDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     deletionDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     createdByAdvisor: true,
    //   ),
    //   UserActionPE(
    //     id: "id",
    //     content: "action retardée",
    //     status: UserActionPEStatus.RETARDED,
    //     endDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     deletionDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     createdByAdvisor: true,
    //   ),
    //   UserActionPE(
    //     id: "id",
    //     content: "action faite",
    //     status: UserActionPEStatus.DONE,
    //     endDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     deletionDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     createdByAdvisor: true,
    //   ),
    //   UserActionPE(
    //     id: "id",
    //     content: "action annulee",
    //     status: UserActionPEStatus.CANCELLED,
    //     endDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     deletionDate: DateTime(2022, 12, 23, 0, 0, 0),
    //     createdByAdvisor: true,
    //   ),
    // ];
  }
}
