import 'package:clock/clock.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';

class InAppFeedbackRepository {
  final FlutterSecureStorage _secureStorage;
  final RemoteConfigRepository _remoteConfigRepository;

  InAppFeedbackRepository(this._secureStorage, this._remoteConfigRepository);

  Future<bool> isFeedbackActivated(String feature) async {
    final inAppFeedbackForFeature = _remoteConfigRepository.inAppFeedbackForFeature(feature);
    if (inAppFeedbackForFeature == null) return false;
    if (clock.now().isAfter(inAppFeedbackForFeature.until)) return false;
    final displayCount = await _incrementDisplayCount(feature);
    return displayCount >= inAppFeedbackForFeature.displayAfter;
  }

  Future<void> dismissFeedback(String feature) async {
    await _secureStorage.write(key: _key(feature), value: '-100000');
  }

  Future<int> _incrementDisplayCount(String feature) async {
    final displayCount = await _secureStorage.read(key: _key(feature)) ?? '0';
    final displayCountIncremented = int.parse(displayCount) + 1;
    await _secureStorage.write(key: _key(feature), value: displayCountIncremented.toString());
    return displayCountIncremented;
  }

  String _key(String feature) => 'display-count-for-feature-$feature';
}
