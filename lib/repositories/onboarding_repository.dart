import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';

class OnboardingRepository {
  final FlutterSecureStorage _preferences;

  static const _key = 'onboardingStatus';

  OnboardingRepository(this._preferences);

  Future<void> save(Onboarding onboarding) async {
    await _preferences.write(key: _key, value: jsonEncode(onboarding.toJson()));
  }

  Future<Onboarding> get() async {
    final result = await _preferences.read(key: _key);
    if (result == null) return Onboarding.initial();
    return Onboarding.fromJson(jsonDecode(result) as Map<String, dynamic>);
  }
}
