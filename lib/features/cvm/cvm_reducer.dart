import 'dart:io';

import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';

DateTime? _cvmBeginSetupDate;
DateTime? _cvmEndSetupDate;
bool? _cvmSetupTracked;

CvmState cvmReducer(CvmState current, dynamic action) {
  _trackCvmSetupTime(action);
  _trackCvmState(current, action);
  if (action is CvmLoadingAction) return CvmLoadingState();
  if (action is CvmFailureAction) return CvmFailureState();
  if (action is CvmSuccessAction) {
    final messages = action.messages;

    final Map<String, CvmMessage> messagesMap = {};
    for (final message in messages) {
      if (!messagesMap.containsKey(message.id)) {
        messagesMap[message.id] = message;
      }
    }
    final filteredMessages = messagesMap.values.toList();

    return CvmSuccessState(filteredMessages);
  }
  if (action is CvmResetAction) return CvmNotInitializedState();
  return current;
}

void _trackCvmSetupTime(dynamic action) {
  if (_cvmSetupTracked == true) return;
  if (_cvmBeginSetupDate == null && action is CvmLoadingAction) _cvmBeginSetupDate = DateTime.now();
  if (_cvmEndSetupDate == null && action is CvmSuccessAction) _cvmEndSetupDate = DateTime.now();
  if (_cvmBeginSetupDate != null && _cvmEndSetupDate != null) {
    _cvmSetupTracked = true;
    final duration = _cvmEndSetupDate!.difference(_cvmBeginSetupDate!).inSeconds;
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.cvmLoadingCategory,
      action: Platform.isIOS ? AnalyticsEventNames.cvmLoadingIosAction : AnalyticsEventNames.cvmLoadingAndroidAction,
      eventName: AnalyticsEventNames.cvmLoadingEventName,
      eventValue: duration,
    );
  }
}

void _trackCvmState(CvmState current, dynamic action) {
  if (current is! CvmSuccessState && action is CvmSuccessAction) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.cvmResultCategory,
      action: Platform.isIOS
          ? AnalyticsEventNames.cvmResultIosSuccessAction
          : AnalyticsEventNames.cvmResultAndroidSuccessAction,
    );
  }
  if (action is CvmFailureAction) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.cvmResultCategory,
      action: Platform.isIOS
          ? AnalyticsEventNames.cvmResultIosFailureAction
          : AnalyticsEventNames.cvmResultAndroidFailureAction,
    );
  }
}
