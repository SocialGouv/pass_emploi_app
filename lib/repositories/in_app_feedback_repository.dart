import 'package:clock/clock.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/feedback_activation.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';

class InAppFeedbackRepository {
  final FlutterSecureStorage _secureStorage;
  final RemoteConfigRepository _remoteConfigRepository;

  InAppFeedbackRepository(this._secureStorage, this._remoteConfigRepository);

  Future<FeedbackActivation> getFeedbackActivation(String feature) async {
    final inAppFeedbackForFeature = _remoteConfigRepository.inAppFeedbackForFeature(feature);
    if (inAppFeedbackForFeature == null) {
      return FeedbackActivation(
        isActivated: false,
        commentaireEnabled: false,
        dismissable: true,
      );
    }
    if (clock.now().isAfter(inAppFeedbackForFeature.until)) {
      return FeedbackActivation(
        isActivated: false,
        commentaireEnabled: false,
        dismissable: true,
      );
    }
    final displayCount = await _incrementDisplayCount(feature);
    final isActivated = displayCount >= inAppFeedbackForFeature.displayAfter;
    return FeedbackActivation(
      isActivated: isActivated,
      commentaireEnabled: inAppFeedbackForFeature.commentaireEnabled,
      dismissable: inAppFeedbackForFeature.dismissable,
    );
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
