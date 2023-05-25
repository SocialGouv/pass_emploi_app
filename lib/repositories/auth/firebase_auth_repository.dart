import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class FirebaseAuthRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  FirebaseAuthRepository(this._httpClient, [this._crashlytics]);

  Future<FirebaseAuthResponse?> getFirebaseAuth(String userId) async {
    const url = '/auth/firebase/token';
    try {
      final response = await _httpClient.post(url);
      return FirebaseAuthResponse.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}

class FirebaseAuthResponse extends Equatable {
  final String token;
  final String key;

  FirebaseAuthResponse({required this.token, required this.key});

  factory FirebaseAuthResponse.fromJson(dynamic json) {
    return FirebaseAuthResponse(
      token : json["token"] as String,
      key : json["cle"] as String,
    );
  }

  @override
  List<Object> get props => [token, key];
}
