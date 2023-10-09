import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class ChatSecurityRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ChatSecurityRepository(this._httpClient, [this._crashlytics]);

  Future<ChatSecurityResponse?> getChatSecurityToken(String userId) async {
    const url = '/auth/firebase/token';
    try {
      final response = await _httpClient.post(url);
      return ChatSecurityResponse.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}

class ChatSecurityResponse extends Equatable {
  final String token;
  final String key;

  ChatSecurityResponse({required this.token, required this.key});

  factory ChatSecurityResponse.fromJson(dynamic json) {
    return ChatSecurityResponse(
      token: json["token"] as String,
      key: json["cle"] as String,
    );
  }

  @override
  List<Object> get props => [token, key];
}
