import 'dart:io';

import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';

DateTime? _cvmBeginSetupDate;
DateTime? _cvmEndSetupDate;
bool? _cvmSetupTracked;

CvmState cvmReducer(CvmState current, dynamic action) {
  _trackCvmSetupTime(action);
  if (action is CvmLoadingAction) return CvmLoadingState();
  if (action is CvmFailureAction) return CvmFailureState();
  if (action is CvmSuccessAction) return CvmSuccessState(action.messages);
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
      eventCategory: AnalyticsEventNames.cvmCategory,
      action: Platform.isIOS ? AnalyticsEventNames.cvmLoadingIosAction : AnalyticsEventNames.cvmLoadingAndroidAction,
      eventName: AnalyticsEventNames.cvmLoadingEventName,
      eventValue: duration,
    );
  }
}
